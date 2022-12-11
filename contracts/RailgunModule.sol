// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.7;

import "@gnosis.pm/zodiac/contracts/core/Module.sol";
import {BabyJubJub, Point} from "./lib/LibBabyJubJub.sol";
import {PoseidonT6} from "./lib/Poseidon.sol";

interface IRailgun {
    function messageSender() external view returns (address);

    function messageId() external view returns (bytes32);

    function messageSourceChainId() external view returns (bytes32);
}

struct Signature {
    Point R;
    uint256 s;
}

contract RailgunModule is Module {
    event RailgunModuleSetup(
        address indexed initiator,
        address indexed owner,
        address indexed avatar,
        address target,
        IRailgun railgun
    );
    event ControllerSet(Point controller);
    event RailgunSet(IRailgun railgun);

    /// @notice Can only be called by the railgun contract.
    error UnauthorizedCaller();
    /// @notice Invalid message.
    error InvalidMessage();
    /// @notice Railgun address aleady set to this address.
    error RailgunAddressAlreadySet();
    /// @notice Controller public key already set to this point.
    error ControllerPublicKeyAlreadySet();
    /// @notice Module transaction failed.
    error ModuleTransactionFailed();

    IRailgun public railgun;
    Point public controller;

    /// @param _owner Address of the  owner.
    /// @param _avatar Address of the avatar (e.g. a Safe).
    /// @param _target Address of the contract that will call exec function.
    /// @param _railgun Address of the Railgun contract.
    /// @param _controller Public key of the conotroller on Railgun.
    constructor(
        address _owner,
        address _avatar,
        address _target,
        IRailgun _railgun,
        Point memory _controller
    ) {
        bytes memory initParams = abi.encode(_owner, _avatar, _target, _railgun, _controller);
        setUp(initParams);
    }

    function setUp(bytes memory initParams) public override {
        (address _owner, address _avatar, address _target, IRailgun _railgun, Point memory _controller) = abi.decode(
            initParams,
            (address, address, address, IRailgun, Point)
        );
        __Ownable_init();
        setAvatar(_avatar);
        setTarget(_target);
        setRailgun(_railgun);
        setController(_controller);
        transferOwnership(_owner);
        emit RailgunModuleSetup(msg.sender, _owner, _avatar, _target, _railgun);
    }

    /// @dev Executes a transaction initated by the Railgun.
    /// @param to Target of the transaction that should be executed.
    /// @param value Wei value of the transaction that should be executed.
    /// @param data Data of the transaction that should be executed.
    /// @param operation Operation (Call or Delegatecall) of the transaction that should be executed.
    /// @notice Can only be called by the Railgun contract.
    function executeTransaction(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation
    ) public {
        if (msg.sender != address(railgun)) revert UnauthorizedCaller();
        /// TODO: generate message hash
        /// TODO: decode signature
        verify(messageHash, signature, controller);
        if (!exec(to, value, data, operation)) revert ModuleTransactionFailed();
    }

    function verify(
        bytes32 _messageHash,
        Signature memory _signature,
        Point memory _publicKey
    ) internal view returns (bool) {
        // Validate inputs
        require(BabyJubJub.isOnCurve(_signature.R), "Signature R point not in curve");
        require(BabyJubJub.isOnCurve(_publicKey), "Public key point not in curve");
        require(_signature.s < BabyJubJub.Q / 3, "Signature scalar not in suborder");

        // Calculate signature hash
        bytes32 sigHash = PoseidonT6.poseidon(
            [
                bytes32(_signature.R.x),
                bytes32(_signature.R.y),
                bytes32(_publicKey.x),
                bytes32(_publicKey.y),
                _messageHash
            ]
        );

        // Calculate verification points
        Point memory left = BabyJubJub.scalarMultiply(BabyJubJub.generator(), _signature.s);
        Point memory right = BabyJubJub.scalarMultiply(_publicKey, uint256(sigHash));

        // Verify signature points
        if (left.x != right.x) return false;
        if (left.y != right.y) return false;
        return true;
    }

    /// @dev Set the Railgun contract address.
    /// @param _railgun Address of the Railgun contract.
    /// @notice This can only be called by the `owner.
    function setRailgun(IRailgun _railgun) public onlyOwner {
        if (address(railgun) == address(_railgun)) revert RailgunAddressAlreadySet();
        railgun = _railgun;
        emit RailgunSet(_railgun);
    }

    /// @dev Set the public key of the conotroller on Railgun.
    /// @param _controller Public key of the conotroller on Railgun.
    /// @notice This can only be called by the `owner`.
    function setController(Point memory _controller) public onlyOwner {
        if (controller.x == _controller.x && controller.y == _controller.y) revert ControllerPublicKeyAlreadySet();
        controller = _controller;
        emit ControllerSet(_controller);
    }
}
