// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

library ImageMap {
    function generateImageMap(uint16[] memory randomData) public pure returns (uint8[] memory) {
        uint8 width = 10;
        uint8 height = 10;
        uint8 dataWidth = width / 2;

        uint8 idx;
        uint8 randomDataIdx;
        uint8[] memory imageData = new uint8[](100);
        for (uint8 y = 0; y < height; y++) {
            for (uint8 x = 0; x < dataWidth; x++) {
                uint16 randomWord = randomData[randomDataIdx];
                uint8 pixelType = uint8((randomWord * 23) / 1000); // 43% foreground, 43% background, 14% spot
                imageData[idx] = pixelType;
                idx++;
                randomDataIdx++;
            }
            // Mirror
            for (uint8 x = 0; x < dataWidth; x++) {
                imageData[idx] = imageData[idx - ((2 * x) + 1)];
                idx++;
            }
        }
        return imageData;
    }
}
