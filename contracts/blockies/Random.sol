// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "./Color.sol";
import "./StringTools.sol";

library Random {
    function generateColorBytes(uint16[] memory random, uint8 idx) public pure returns (uint8[3] memory) {
        uint8 offset = 0;
        uint16 hue = (uint16(random[idx + offset]) * 36) / 10; // Between 0-360
        offset++;
        uint16 saturation = ((uint16(random[idx + offset]) * 6) + 400) / 10; // Between 40-100
        offset++;

        // Between 0-100 but probabilities are a bell curve around 50%
        uint16 lightness = (uint16(
            (random[idx + offset] + random[idx + offset + 1] + random[idx + offset + 2] + random[idx + offset + 3])
        ) * 25) / 100;
        (uint8 r, uint8 b, uint8 g) = Color.convertHslToRgb(hue, saturation, lightness);
        return [r, g, b];
    }

    function generateColorHexString(uint16[] memory randomData, uint8 idx) public pure returns (string memory) {
        uint8[3] memory colorBytes = generateColorBytes(randomData, idx);
        bytes memory colorBytesMerged = new bytes(3);
        colorBytesMerged[0] = bytes1(colorBytes[0]);
        colorBytesMerged[1] = bytes1(colorBytes[1]);
        colorBytesMerged[2] = bytes1(colorBytes[2]);
        return StringTools.hexStringFromBytes(colorBytesMerged);
    }

    function generateData(bytes memory seed) public pure returns (uint16[] memory) {
        // 50 (unique bytes, not including mirror bytes) + (3 * 6) (3 colors, each requiring 6 random numbers)
        uint8 randomDataLength = 68;
        uint16[] memory randomData = new uint16[](randomDataLength);
        for (uint256 idx = 0; idx < randomDataLength; idx++) {
            seed = abi.encodePacked(keccak256(seed));
            uint16 rand = uint16(uint256(keccak256(seed)));
            randomData[idx] = rand - (rand / 100) * 100; // Between 0-100
        }
        return randomData;
    }
}
