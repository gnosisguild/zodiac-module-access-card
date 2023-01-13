// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.0;

import "../blockies/Blockies.sol";

contract BlockiesTest {
    function renderSVG(address who) public pure returns (string memory) {
        return Blockies.renderSVG(who);
    }
}
