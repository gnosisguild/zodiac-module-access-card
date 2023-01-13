// SPDX-License-Identifier: WTFPL
pragma solidity 0.8.17;

/// @notice What if Blockies were NFTs. That is what this collection is all about.
/// Check your wallet as every ethereum address already owns its own Blocky NFT. No minting needed.
/// You can even use Permit (EIP-4494) to approve transfers from smart contracts, via signatures.
/// Note that unless you transfer or call `emitSelfTransferEvent` / `emitMultipleSelfTransferEvents` first, indexers would not know of your token.
/// So if you want your Blocky to shows up, you can call `emitSelfTransferEvent(<your address>)` for ~ 26000 gas.
/// If you are interested in multiple blockies, you can also call `emitMultipleSelfTransferEvents` for ~ 21000 + ~ 5000 gas per blocky.
/// @title On-chain Blockies
contract Blockies {
    bytes internal constant SVG_TEMPLATE =
        "<svg xmlns='http://www.w3.org/2000/svg' shape-rendering='crispEdges' width='512' height='512'><g transform='scale(64)'><path fill='hsl(000,000%,000%)' d='M0,0h8v8h-8z'/><path fill='hsl(000,000%,000%)' d='M0,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1z'/><path fill='hsl(000,000%,000%)' d='M0,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1z'/></g></svg>";

    uint256 internal constant COLOR_BG_POS = 168;

    uint256 internal constant COLOR_1_POS = 222;
    uint256 internal constant PATH_1_POS = COLOR_1_POS + 18;

    uint256 internal constant COLOR_2_POS = 1067;
    uint256 internal constant PATH_2_POS = COLOR_2_POS + 18;

    bytes internal constant hexAlphabet = "0123456789abcdef";

    struct Seed {
        int32 s0;
        int32 s1;
        int32 s2;
        int32 s3;
    }

    function _writeUint(bytes memory data, uint256 endPos, uint256 num) internal pure {
        while (num != 0) {
            data[endPos--] = bytes1(uint8(48 + (num % 10)));
            num /= 10;
        }
    }

    function _seedrand(bytes memory seed) internal pure returns (Seed memory randseed) {
        unchecked {
            for (uint256 i = 0; i < seed.length; i++) {
                uint8 j = uint8(i % 4);
                if (j == 0) {
                    randseed.s0 = (randseed.s0 << 5) - randseed.s0 + int32(uint32(uint8(seed[i])));
                } else if (j == 1) {
                    randseed.s1 = (randseed.s1 << 5) - randseed.s1 + int32(uint32(uint8(seed[i])));
                } else if (j == 2) {
                    randseed.s2 = (randseed.s2 << 5) - randseed.s2 + int32(uint32(uint8(seed[i])));
                } else if (j == 3) {
                    randseed.s3 = (randseed.s3 << 5) - randseed.s3 + int32(uint32(uint8(seed[i])));
                }
            }
        }
    }

    function _rand(Seed memory randseed) internal pure returns (uint256 rnd) {
        unchecked {
            int32 t = randseed.s0 ^ int32(randseed.s0 << 11);
            randseed.s0 = randseed.s1;
            randseed.s1 = randseed.s2;
            randseed.s2 = randseed.s3;
            randseed.s3 = randseed.s3 ^ (randseed.s3 >> 19) ^ t ^ (t >> 8);
            rnd = uint32(randseed.s3);
        }
    }

    function _randhsl(Seed memory randseed) internal pure returns (uint16 hue, uint8 saturation, uint8 lightness) {
        unchecked {
            // saturation is the whole color spectrum
            hue = uint16(((_rand(randseed) * 360) / 2147483648));
            // saturation goes from 40 to 100, it avoids greyish colors
            saturation = uint8((_rand(randseed) * 60) / 2147483648 + 40);
            // lightness can be anything from 0 to 100, but probabilities are a bell curve around 50%
            lightness = uint8(
                ((_rand(randseed) + _rand(randseed) + _rand(randseed) + _rand(randseed)) * 25) / 2147483648
            );
        }
    }

    function _setColor(bytes memory metadata, Seed memory randseed, uint8 i) internal pure {
        (uint16 hue, uint8 saturation, uint8 lightness) = _randhsl(randseed);
        uint256 pos = COLOR_BG_POS;
        if (i == 1) {
            pos = COLOR_1_POS;
        } else if (i == 2) {
            pos = COLOR_2_POS;
        }
        _writeUint(metadata, pos + 0, hue);
        _writeUint(metadata, pos + 4, saturation);
        _writeUint(metadata, pos + 9, lightness);
    }

    function _writeUintAsHex(bytes memory data, uint256 endPos, uint256 num) internal pure {
        while (num != 0) {
            data[endPos--] = bytes1(hexAlphabet[num % 16]);
            num /= 16;
        }
    }

    function _addressToString(address who) internal pure returns (string memory) {
        bytes memory addr = "0x0000000000000000000000000000000000000000";
        _writeUintAsHex(addr, 41, uint160(who));
        return string(addr);
    }

    function _setPixel(bytes memory metadata, uint256 x, uint256 y, uint8 color) internal pure {
        uint256 pathPos = 0;
        if (color == 0) {
            return;
        }
        if (color == 1) {
            pathPos = PATH_1_POS;
        } else if (color == 2) {
            pathPos = PATH_2_POS;
        }
        uint256 pos = pathPos + y * 5 + (y * 8 + x) * 12 + 8;
        metadata[pos] = "1";
    }

    function renderSVG(address who) public pure returns (string memory) {
        bytes memory svg = SVG_TEMPLATE;

        Seed memory randseed = _seedrand(bytes(_addressToString(who)));

        _setColor(svg, randseed, 1);
        _setColor(svg, randseed, 0);
        _setColor(svg, randseed, 2);

        for (uint256 y = 0; y < 8; y++) {
            uint8 p0 = uint8((_rand(randseed) * 23) / 2147483648 / 10);
            uint8 p1 = uint8((_rand(randseed) * 23) / 2147483648 / 10);
            uint8 p2 = uint8((_rand(randseed) * 23) / 2147483648 / 10);
            uint8 p3 = uint8((_rand(randseed) * 23) / 2147483648 / 10);

            _setPixel(svg, 0, y, p0);
            _setPixel(svg, 1, y, p1);
            _setPixel(svg, 2, y, p2);
            _setPixel(svg, 3, y, p3);
            _setPixel(svg, 4, y, p3);
            _setPixel(svg, 5, y, p2);
            _setPixel(svg, 6, y, p1);
            _setPixel(svg, 7, y, p0);
        }

        return string(svg);
    }
}
