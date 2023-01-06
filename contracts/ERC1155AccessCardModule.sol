// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.7;

import "@gnosis.pm/zodiac/contracts/core/Module.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

struct AccessCard {
    IERC1155 tokenContract;
    uint256 tokenId;
}

contract ERC1155AccessCardModule is Module {
    event AccessCardModuleSetup(
        address indexed initiator,
        address indexed owner,
        address indexed avatar,
        address target,
        AccessCard accessCard
    );
    /// @dev Emitted each time the access card address is set
    event AccessCardSet(AccessCard accessCard);

    /// @notice Can only be called by holder of the access card.
    error AccessDenied();
    /// @notice AccessCard aleady set to this address and ID.
    error AccessCardAlreadySet();
    /// @notice Module transaction failed.
    error ModuleTransactionFailed();

    /// @dev Address and id of NFT to be used as an access card.
    AccessCard public accessCard;

    /// @param _owner Address of the  owner.
    /// @param _avatar Address of the avatar (e.g. a Safe).
    /// @param _target Address of the contract that will call exec function.
    /// @param _accessCard Address and ID of the NFT to be used as an access card.
    constructor(address _owner, address _avatar, address _target, AccessCard memory _accessCard) {
        bytes memory initParams = abi.encode(_owner, _avatar, _target, _accessCard);
        setUp(initParams);
    }

    function setUp(bytes memory initParams) public override {
        (address _owner, address _avatar, address _target, AccessCard memory _accessCard) = abi.decode(
            initParams,
            (address, address, address, AccessCard)
        );
        __Ownable_init();
        setAvatar(_avatar);
        setTarget(_target);
        setAccessCard(_accessCard);
        transferOwnership(_owner);
        emit AccessCardModuleSetup(msg.sender, _owner, _avatar, _target, _accessCard);
    }

    modifier swipeAccessCard() {
        if (accessCard.tokenContract.balanceOf(msg.sender, accessCard.tokenId) == 0) revert AccessDenied();
        _;
    }

    /// @dev Triggers target to execute a given transaction.
    /// @param to Target of the transaction that should be executed.
    /// @param value Native token value, in wei, of the transaction that should be executed.
    /// @param data Data of the transaction that should be executed.
    /// @param operation Operation (Call or Delegatecall) of the transaction that should be executed.
    /// @notice Can only be called by the holder of the access card.
    function executeTransaction(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation
    ) public swipeAccessCard {
        if (!exec(to, value, data, operation)) revert ModuleTransactionFailed();
    }

    /// @dev Set the Railgun contract address.
    /// @param _accessCard Address of the Railgun contract.
    /// @notice This can only be called by the `owner.
    function setAccessCard(AccessCard memory _accessCard) public onlyOwner {
        if (accessCard.tokenContract == _accessCard.tokenContract && accessCard.tokenId == _accessCard.tokenId)
            revert AccessCardAlreadySet();
        accessCard = _accessCard;
        emit AccessCardSet(_accessCard);
    }
}
