// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./SVG.sol";
import "./Utils.sol";

contract Renderer {
    function render(uint256 _tokenId, address holderAddress) public pure returns (string memory) {
        return
            string.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" width="700" height="700" viewBox="0 0 2700 2700" fill="none">',
                "<style>.rect {fill: #D9D4AD;fill-opacity: 0.01;stroke: #D9D4AD;stroke-opacity: 0.3;stroke-width: 5;}.textRect {fill-opacity: 0.1}</style>",
                rectangles(),
                svg.el(
                    "defs",
                    utils.NULL,
                    svg.linearGradient(
                        string.concat(
                            svg.prop("id", "bgLinear"),
                            svg.prop("x1", "533.841"),
                            svg.prop("y1", "50"),
                            svg.prop("x2", "2674.45"),
                            svg.prop("y2", "602.148")
                        ),
                        string.concat(
                            svg.el("stop", svg.prop("stop-color", "#080229"), utils.NULL),
                            svg.el(
                                "stop",
                                string.concat(
                                    svg.prop("stop-color", "#1F190A"),
                                    svg.prop("offset", "0.546875"),
                                    svg.prop("offset", "0.998969")
                                ),
                                utils.NULL
                            )
                        )
                    )
                ),
                "</svg>"
            );
    }

    function example() external pure returns (string memory) {
        return render(1, 0xD476B79539781e499396761CE7e21ab28AeA828F);
    }

    function rectangles() internal pure returns (string memory) {
        return
            '<rect x="550" y="50" width="1600" height="2600" rx="64" fill="url(#bgLinear)"/><rect x="702.5" y="202.5" width="1295" height="268.183" class="rect textRect"/><rect x="672.5" y="172.5" width="1355" height="328.183" class="rect"/><rect x="642.5" y="142.5" width="1415" height="388.183" class="rect"/><rect x="672.5" y="595.683" width="204" height="204" class="rect"/><rect x="642.5" y="565.683" width="264" height="264" class="rect"/><rect x="1065.25" y="696.524" width="171.5" height="1" class="rect" stroke="#D9D4AD"/><rect x="1036.5" y="660.683" width="229" height="74.1829" class="rect"/><rect x="1002.5" y="626.683" width="297" height="142.183" class="rect"/><rect x="971.5" y="595.683" width="359" height="204.183" class="rect"/><rect x="941.5" y="565.683" width="419" height="264.183" class="rect"/><rect x="1455.5" y="625.683" width="542" height="144.183" class="rect textRect"/><rect x="1425.5" y="595.683" width="602" height="204.183" class="rect"/><rect x="1395.5" y="565.683" width="662" height="264.183" class="rect"/><rect x="702.5" y="924.866" width="1299" height="127" class="rect textRect"/><rect x="672.5" y="894.866" width="1359" height="187" class="rect"/><rect x="642.5" y="864.866" width="1419" height="247" class="rect"/><rect x="970.25" y="1474.62" width="1" height="70.5" class="rect"/><rect x="942.5" y="1446.87" width="55" height="126" class="rect"/><rect x="912.5" y="1416.87" width="115" height="186" class="rect"/><rect x="882.5" y="1386.87" width="175" height="246" class="rect"/><rect x="852.5" y="1356.87" width="235" height="306" class="rect"/><rect x="822.5" y="1326.87" width="295" height="366" class="rect"/><rect x="792.5" y="1296.87" width="355" height="426" class="rect"/><rect x="762.5" y="1266.87" width="415" height="486" class="rect"/><rect x="732.5" y="1236.87" width="475" height="546" class="rect"/><rect x="702.5" y="1206.87" width="535" height="606" class="rect"/><rect x="672.5" y="1176.87" width="595" height="666" class="rect"/><rect x="642.5" y="1146.87" width="655" height="726" class="rect"/><rect x="1390" y="1204.37" width="610" height="611" fill="url(#pattern0)"/><rect x="1362.5" y="1176.87" width="665" height="666" class="rect"/><rect x="1332.5" y="1146.87" width="725" height="726" class="rect"/><rect x="702.5" y="1967.87" width="367" height="171" class="rect textRect"/><rect x="672.5" y="1937.87" width="427" height="231" class="rect"/><rect x="1251.25" y="2052.12" width="659.5" height="1" class="rect"/><rect x="1222.5" y="2024.87" width="717" height="57" class="rect"/><rect x="1194.5" y="1997.87" width="773" height="111" class="rect"/><rect x="1164.5" y="1967.87" width="833" height="171" class="rect"/><rect x="1134.5" y="1937.87" width="893" height="231" class="rect"/><rect x="702.5" y="2233.87" width="1295" height="264" class="rect textRect"/><rect x="672.5" y="2203.87" width="1355" height="324" class="rect"/><rect x="642.5" y="1907.87" width="1415" height="650" class="rect"/><rect x="612.5" y="112.5" width="1475" height="2475" rx="9.5" class="rect"/><rect x="582.5" y="82.5" width="1535" height="2535" rx="33.5" class="rect"/>';
    }

    //     function rectangles() internal pure returns (string memory) {
    //         return
    //             string.concat(
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("fill", "url(#bgLinear)"),
    //                         svg.prop("x", "550"),
    //                         svg.prop("y", "50"),
    //                         svg.prop("width", "1600"),
    //                         svg.prop("height", "2600"),
    //                         svg.prop("rx", "64")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect textRect"),
    //                         svg.prop("x", "702.5"),
    //                         svg.prop("y", "202.5"),
    //                         svg.prop("width", "1295"),
    //                         svg.prop("height", "268.183")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "672.5"),
    //                         svg.prop("y", "172.5"),
    //                         svg.prop("width", "1355"),
    //                         svg.prop("height", "328.183")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "642.5"),
    //                         svg.prop("y", "142.5"),
    //                         svg.prop("width", "1415"),
    //                         svg.prop("height", "388.183")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "672.5"),
    //                         svg.prop("y", "595.683"),
    //                         svg.prop("width", "204"),
    //                         svg.prop("height", "204")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "642.5"),
    //                         svg.prop("y", "565.683"),
    //                         svg.prop("width", "264"),
    //                         svg.prop("height", "264")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1065.25"),
    //                         svg.prop("y", "696.524"),
    //                         svg.prop("width", "171.5"),
    //                         svg.prop("height", "1")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1036.5"),
    //                         svg.prop("y", "660.683"),
    //                         svg.prop("width", "229"),
    //                         svg.prop("height", "74.1829")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1002.5"),
    //                         svg.prop("y", "626.683"),
    //                         svg.prop("width", "297"),
    //                         svg.prop("height", "142.183")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "971.5"),
    //                         svg.prop("y", "595.683"),
    //                         svg.prop("width", "359"),
    //                         svg.prop("height", "204.183")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "941.5"),
    //                         svg.prop("y", "565.683"),
    //                         svg.prop("width", "419"),
    //                         svg.prop("height", "264.183")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect textRect"),
    //                         svg.prop("x", "1455.5"),
    //                         svg.prop("y", "625.683"),
    //                         svg.prop("width", "542"),
    //                         svg.prop("height", "144.183")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1425.5"),
    //                         svg.prop("y", "595.683"),
    //                         svg.prop("width", "602"),
    //                         svg.prop("height", "204.183")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1395.5"),
    //                         svg.prop("y", "565.683"),
    //                         svg.prop("width", "662"),
    //                         svg.prop("height", "264.183")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect textRect"),
    //                         svg.prop("x", "702.5"),
    //                         svg.prop("y", "924.866"),
    //                         svg.prop("width", "1299"),
    //                         svg.prop("height", "127")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "672.5"),
    //                         svg.prop("y", "894.866"),
    //                         svg.prop("width", "1359"),
    //                         svg.prop("height", "187")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "642.5"),
    //                         svg.prop("y", "864.866"),
    //                         svg.prop("width", "1419"),
    //                         svg.prop("height", "247")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "970.25"),
    //                         svg.prop("y", "1474.62"),
    //                         svg.prop("width", "1"),
    //                         svg.prop("height", "70.5")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "942.5"),
    //                         svg.prop("y", "1446.87"),
    //                         svg.prop("width", "55"),
    //                         svg.prop("height", "126")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "912.5"),
    //                         svg.prop("y", "1416.87"),
    //                         svg.prop("width", "115"),
    //                         svg.prop("height", "186")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "882.5"),
    //                         svg.prop("y", "1386.87"),
    //                         svg.prop("width", "175"),
    //                         svg.prop("height", "246")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "852.5"),
    //                         svg.prop("y", "1356.87"),
    //                         svg.prop("width", "235"),
    //                         svg.prop("height", "306")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "822.5"),
    //                         svg.prop("y", "1326.87"),
    //                         svg.prop("width", "295"),
    //                         svg.prop("height", "366")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "792.5"),
    //                         svg.prop("y", "1296.87"),
    //                         svg.prop("width", "355"),
    //                         svg.prop("height", "426")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "762.5"),
    //                         svg.prop("y", "1266.87"),
    //                         svg.prop("width", "415"),
    //                         svg.prop("height", "486")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "732.5"),
    //                         svg.prop("y", "1236.87"),
    //                         svg.prop("width", "475"),
    //                         svg.prop("height", "546")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "702.5"),
    //                         svg.prop("y", "1206.87"),
    //                         svg.prop("width", "535"),
    //                         svg.prop("height", "606")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "672.5"),
    //                         svg.prop("y", "1176.87"),
    //                         svg.prop("width", "595"),
    //                         svg.prop("height", "666")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "642.5"),
    //                         svg.prop("y", "1146.87"),
    //                         svg.prop("width", "655"),
    //                         svg.prop("height", "726")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1362.5"),
    //                         svg.prop("y", "1176.87"),
    //                         svg.prop("width", "665"),
    //                         svg.prop("height", "666")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1332.5"),
    //                         svg.prop("y", "1146.87"),
    //                         svg.prop("width", "725"),
    //                         svg.prop("height", "726")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "702.5"),
    //                         svg.prop("y", "1967.87"),
    //                         svg.prop("width", "367"),
    //                         svg.prop("height", "171")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "672.5"),
    //                         svg.prop("y", "1937.87"),
    //                         svg.prop("width", "427"),
    //                         svg.prop("height", "231")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1251.25"),
    //                         svg.prop("y", "2052.12"),
    //                         svg.prop("width", "659.5"),
    //                         svg.prop("height", "1")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1222.5"),
    //                         svg.prop("y", "2024.87"),
    //                         svg.prop("width", "717"),
    //                         svg.prop("height", "57")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1194.5"),
    //                         svg.prop("y", "1997.87"),
    //                         svg.prop("width", "773"),
    //                         svg.prop("height", "111")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1164.5"),
    //                         svg.prop("y", "1967.87"),
    //                         svg.prop("width", "833"),
    //                         svg.prop("height", "171")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "1134.5"),
    //                         svg.prop("y", "1937.87"),
    //                         svg.prop("width", "893"),
    //                         svg.prop("height", "231")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect textRect"),
    //                         svg.prop("x", "702.5"),
    //                         svg.prop("y", "2233.87"),
    //                         svg.prop("width", "1295"),
    //                         svg.prop("height", "264")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "672.5"),
    //                         svg.prop("y", "2203.87"),
    //                         svg.prop("width", "1355"),
    //                         svg.prop("height", "324")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "642.5"),
    //                         svg.prop("y", "1907.87"),
    //                         svg.prop("width", "1415"),
    //                         svg.prop("height", "650")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "612.5"),
    //                         svg.prop("y", "112.5"),
    //                         svg.prop("width", "1475"),
    //                         svg.prop("height", "2475"),
    //                         svg.prop("rx", "9.5")
    //                     ),
    //                     utils.NULL
    //                 ),
    //                 svg.rect(
    //                     string.concat(
    //                         svg.prop("class", "rect"),
    //                         svg.prop("x", "582.5"),
    //                         svg.prop("y", "82.5"),
    //                         svg.prop("width", "1535"),
    //                         svg.prop("height", "2535"),
    //                         svg.prop("rx", "33.5")
    //                     ),
    //                     utils.NULL
    //                 )
    //             );
    //     }
}

// svg.text(
//     string.concat(
//         svg.prop("x", "20"),
//         svg.prop("y", "40"),
//         svg.prop("font-size", "22"),
//         svg.prop("fill", "white")
//     ),
//     string.concat(svg.cdata("Zodiac Access Card..."), utils.uint2str(_tokenId))
// ),
