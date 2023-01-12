// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

library Color {
    function convertHslToRgb(uint256 hue, uint256 sat, uint256 lum) public pure returns (uint8 r, uint8 g, uint8 b) {
        hue = (hue * 100 * 255) / 36000;
        sat = (sat * 255) / 100;
        lum = (lum * 255) / 100;
        uint256 v = (lum < 128) ? (lum * (256 + sat)) >> 8 : (((lum + sat) << 8) - lum * sat) >> 8;
        if (v <= 0) {
            r = 0;
            g = 0;
            b = 0;
        } else {
            hue = hue * 6;
            uint256 m = lum * 2 - v;
            uint256 sextant = hue >> 8;
            uint256 fract = hue - (sextant << 8);
            uint256 vsf = ((v * fract * (v - m)) / v) >> 8;
            uint256 mid1 = m + vsf;
            uint256 mid2 = v - vsf;
            assembly {
                switch sextant
                case 0 {
                    r := v
                    g := mid1
                    b := m
                }
                case 1 {
                    r := mid2
                    g := v
                    b := m
                }
                case 2 {
                    r := m
                    g := v
                    b := mid1
                }
                case 3 {
                    r := m
                    g := mid2
                    b := v
                }
                case 4 {
                    r := mid1
                    g := m
                    b := v
                }
                case 5 {
                    r := v
                    g := m
                    b := mid2
                }
            }
        }
    }
}
