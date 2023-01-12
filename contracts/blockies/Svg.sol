// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./Strings.sol";
import "./Random.sol";
import "./ImageMap.sol";

contract Svg {
    uint32 constant width = 10;
    uint32 constant height = 10;

    function generateStyles(string memory color1, string memory color2) public pure returns (string memory) {
        string memory stylesTagOpen = '<style type="text/css">';
        string memory colorOneClass = string.concat(".color1{stroke:#", color1, "}"); // string.concat(".color1{stroke:#", color1, "}"));
        string memory colorTwoClass = string.concat(".color2{stroke:#", color2, "}");
        string memory stylesClasses = string.concat(colorOneClass, colorTwoClass);
        string memory stylesTagClose = "</style>";
        string memory styles = string.concat(stylesTagOpen, stylesClasses, stylesTagClose);
        return styles;
    }

    function generateSvgTagOpen(string memory color0) public pure returns (string memory) {
        string
            memory svgTagOpenStart = '<svg pureBox="0 -5 100 100" stroke-width="10" width="100" height="100" style="background-color:#';
        string memory svgTagOpenEnd = ';">';
        string memory svgTagOpen = string.concat(svgTagOpenStart, color0, svgTagOpenEnd);
        return svgTagOpen;
    }

    function generatePaths(uint8[] memory imageMap) public pure returns (string memory) {
        string memory content;
        string memory pathStart = '<path class="';
        string memory dStart = '" d="m';
        string memory closeTag = "/>";
        string memory paths;
        string memory color1ClassName = "color1";
        string memory color2ClassName = "color2";
        uint8 ptr;
        for (uint8 rowIdx = 0; rowIdx < height; rowIdx++) {
            uint8 lastColorType;
            string memory className;
            string memory currentPath;
            for (uint8 colIdx = 0; colIdx < width; colIdx++) {
                uint8 colorType = imageMap[ptr];
                if (colorType == 0) {
                    lastColorType = colorType;
                    ptr++;
                    continue;
                }
                if (colorType == 1) {
                    className = color1ClassName;
                } else if (colorType == 2) {
                    className = color2ClassName;
                }
                lastColorType = colorType;
                string memory xPos = Strings.itoa(colIdx * 10, 10);
                string memory yPos = Strings.itoa(rowIdx * 10, 10);
                currentPath = string.concat(pathStart, className, dStart, xPos, " ", yPos, " ", 'h10"', "/>");

                paths = string.concat(paths, currentPath);
                ptr++;
            }
        }
        return paths;
    }

    function generateSvg(bytes memory seed) external pure returns (string memory) {
        // Generate color data, image mapping and random data based on seed
        uint16[] memory randomData = Random.generateData(seed);
        uint8[] memory imageMap = ImageMap.generateImageMap(randomData);
        string memory color0 = Random.generateColorHexString(randomData, 50);
        string memory color1 = Random.generateColorHexString(randomData, 56);
        string memory color2 = Random.generateColorHexString(randomData, 62);

        // Start to construct the SVG
        string memory svgTagOpen = generateSvgTagOpen(color0);
        string memory styles = generateStyles(color1, color2);

        // Build SVG paths
        string memory paths = generatePaths(imageMap);

        // Merge SVG sections and return the result
        string memory svgTagClose = "</svg>";
        string memory svg = string.concat(svgTagOpen, styles, paths, svgTagClose);
        return svg;
    }
}
