// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./Blockies.sol";
import "./ZodiacBadge.sol";

contract Renderer {
    function render(uint256 tokenId, address holderAddress, address tokenAddress) public pure returns (string memory) {
        return
            string.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" width="700" height="700" viewBox="0 0 2700 2700" fill="none">',
                "<style>.rect {fill: #D9D4AD;fill-opacity: 0.01;stroke: #D9D4AD;stroke-opacity: 0.3;stroke-width: 5;}.textRect {fill-opacity: 0.1}.textMedium {font-size: 96px;}.textSmall {font-size: 50px;}.mono {font-family: monospace;}text {fill: white;white-space: pre;letter-spacing: 0;font-family: sans-serif;font-size: 150px;text-anchor: middle;}.textDim {fill: #D9D4AD;fill-opacity: 0.5;}.address {animation: slide 14s steps(150) infinite;text-anchor: start;}@keyframes slide {100% {transform: translateX(-5150px)}}.bgBlend {mix-blend-mode: color-dodge;}.i{mix-blend-mode:screen; opacity:0.8}.z{opacity:0.6}</style>",
                rectangles(),
                text(tokenId, holderAddress, tokenAddress),
                blockie(holderAddress),
                badge(),
                defs(),
                "</svg>"
            );
    }

    function example() external pure returns (string memory) {
        return render(1, 0xD476B79539781e499396761CE7e21ab28AeA828F, 0x8633B1f69DA83067AB1Ec85a3411DE354fBF96cD);
    }

    function rectangles() internal pure returns (string memory) {
        return
            string.concat(
                // bg rect
                '<rect x="550" y="50" width="1600" height="2600" rx="64" fill="url(#bgLinear)"/>',
                // watermark groups and rect
                '<g clip-path="url(#bgClip)" class="bgBlend"><g filter="url(#distort)"><rect x="0" y="0" width="27000" height="27000" transform="scale(.1)" fill="url(#diagonal)"/></g></g>',
                // all other rects
                '<rect x="702.5" y="202.5" width="1295" height="268.183" class="rect textRect"/><rect x="672.5" y="172.5" width="1355" height="328.183" class="rect"/><rect x="642.5" y="142.5" width="1415" height="388.183" class="rect"/><rect x="672.5" y="595.683" width="204" height="204" class="rect"/><rect x="642.5" y="565.683" width="264" height="264" class="rect"/><rect x="1065.25" y="696.524" width="171.5" height="1" class="rect" stroke="#D9D4AD"/><rect x="1036.5" y="660.683" width="229" height="74.1829" class="rect"/><rect x="1002.5" y="626.683" width="297" height="142.183" class="rect"/><rect x="971.5" y="595.683" width="359" height="204.183" class="rect"/><rect x="941.5" y="565.683" width="419" height="264.183" class="rect"/><rect x="1455.5" y="625.683" width="542" height="144.183" class="rect textRect"/><rect x="1425.5" y="595.683" width="602" height="204.183" class="rect"/><rect x="1395.5" y="565.683" width="662" height="264.183" class="rect"/><rect x="702.5" y="924.866" width="1299" height="127" class="rect textRect"/><rect x="672.5" y="894.866" width="1359" height="187" class="rect"/><rect x="642.5" y="864.866" width="1419" height="247" class="rect"/><rect x="970.25" y="1474.62" width="1" height="70.5" class="rect"/><rect x="942.5" y="1446.87" width="55" height="126" class="rect"/><rect x="912.5" y="1416.87" width="115" height="186" class="rect"/><rect x="882.5" y="1386.87" width="175" height="246" class="rect"/><rect x="852.5" y="1356.87" width="235" height="306" class="rect"/><rect x="822.5" y="1326.87" width="295" height="366" class="rect"/><rect x="792.5" y="1296.87" width="355" height="426" class="rect"/><rect x="762.5" y="1266.87" width="415" height="486" class="rect"/><rect x="732.5" y="1236.87" width="475" height="546" class="rect"/><rect x="702.5" y="1206.87" width="535" height="606" class="rect"/><rect x="672.5" y="1176.87" width="595" height="666" class="rect"/><rect x="642.5" y="1146.87" width="655" height="726" class="rect"/><rect x="1390" y="1204.37" width="610" height="611" fill="url(#pattern0)"/><rect x="1362.5" y="1176.87" width="665" height="666" class="rect"/><rect x="1332.5" y="1146.87" width="725" height="726" class="rect"/><rect x="702.5" y="1967.87" width="367" height="171" class="rect textRect"/><rect x="672.5" y="1937.87" width="427" height="231" class="rect"/><rect x="1251.25" y="2052.12" width="659.5" height="1" class="rect"/><rect x="1222.5" y="2024.87" width="717" height="57" class="rect"/><rect x="1194.5" y="1997.87" width="773" height="111" class="rect"/><rect x="1164.5" y="1967.87" width="833" height="171" class="rect"/><rect x="1134.5" y="1937.87" width="893" height="231" class="rect"/><rect x="702.5" y="2233.87" width="1295" height="264" class="rect textRect"/><rect x="672.5" y="2203.87" width="1355" height="324" class="rect"/><rect x="642.5" y="1907.87" width="1415" height="650" class="rect"/><rect x="612.5" y="112.5" width="1475" height="2475" rx="9.5" class="rect"/><rect x="582.5" y="82.5" width="1535" height="2535" rx="33.5" class="rect"/>'
            );
    }

    function text(uint256 tokenId, address holderAddress, address tokenAddress) internal pure returns (string memory) {
        return
            string.concat(
                '<text x="1350" y="390.815">Access Card</text>',
                '<text class="textDim textMedium" x="886" y="2088.27">Owner</text>',
                '<text class="textMedium mono" x="1726.5" y="734.712">',
                uint2str(tokenId),
                "</text>",
                '<text class="textDim textSmall mono" x="1352" y="1008.37">',
                Strings.toHexString(uint160(tokenAddress), 20),
                "</text>",
                '<g clip-path="url(#ownClip)"><text class="mono address" x="2000" y="2423.58">',
                Strings.toHexString(uint160(holderAddress), 20),
                "</text></g>"
            );
    }

    function defs() internal pure returns (string memory) {
        return
            string.concat(
                "<defs>",
                // gradient
                '<linearGradient id="bgLinear" x1="533.841" y1="50" x2="2674.45" y2="602.148" gradientUnits="userSpaceOnUse"><stop stop-color="#080229"/><stop offset="0.546875" stop-color="#1F190A"/><stop offset="0.998969" stop-color="#140005"/></linearGradient>',
                // holder address clip path
                '<clipPath id="ownClip"><rect x="705" y="2231.37" width="1290" height="269" fill="white"/></clipPath>',
                // pattern for watermark
                '<pattern id="diagonal" patternUnits="userSpaceOnUse" width="6000" height="6000"><path d="M 0 0 l 10000 10000" stroke="#D9D4AD" stroke-opacity="1" stroke-width="20"/></pattern>',
                // clip path for watermark
                '<clipPath id="bgClip"><rect x="550" y="50" width="1600" height="2600" rx="64" fill="white"/></clipPath>',
                // filter for watermark
                '<filter id="distort"><feTurbulence baseFrequency="0.0015" seed="67" numOctaves="2" type="fractalNoise"/><feDisplacementMap in="SourceGraphic" xChannelSelector="B" yChannelSelector="R" scale="1400"/><feGaussianBlur stdDeviation="4"/><feComponentTransfer><feFuncA type="table" tableValues="0 0.3 0.1 0.1 1 1 1 1 1 1 1 1 1"/></feComponentTransfer></filter>',
                "</defs>"
            );
    }

    function blockie(address holderAddress) internal pure returns (string memory) {
        return
            string.concat(
                '<image class="i" x="1390" y="1204.37" width="610" height="610" href="',
                Blockies.renderSVG(holderAddress),
                '"/>'
            );
    }

    function badge() internal pure returns (string memory) {
        return
            string.concat(
                '<image class="z" x="700" y="623" width="150" height="150" href="',
                ZodiacBadge.renderSVG(),
                '"/>'
            );
    }

    // converts an unsigned integer to a string
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
