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
    bytes public constant SVG_TEMPLATE =
        "data:image/svg+xml,<svg%20xmlns='http://www.w3.org/2000/svg'%20shape-rendering='crispEdges'%20width='512'%20height='512'><g%20transform='scale(64)'><path%20fill='hsl(000,000%,000%)'%20d='M0,0h8v8h-8z'/><path%20fill='hsl(000,000%,000%)'%20d='M0,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1z'/><path%20fill='hsl(000,000%,000%)'%20d='M0,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1z'/></g></svg>";
    uint256 public constant COLOR_BG_POS = 168;

    uint256 public constant COLOR_1_POS = 222;
    uint256 public constant PATH_1_POS = COLOR_1_POS + 18;

    uint256 public constant COLOR_2_POS = 1067;
    uint256 public constant PATH_2_POS = COLOR_2_POS + 18;

    bytes public constant hexAlphabet = "0123456789abcdef";

    struct Seed {
        int32 s0;
        int32 s1;
        int32 s2;
        int32 s3;
    }

    function _writeUint(
        bytes memory data,
        uint256 endPos,
        uint256 num
    ) public pure returns (bytes memory) {
        while (num != 0) {
            data[endPos--] = bytes1(uint8(48 + (num % 10)));
            num /= 10;
        }
        return data;
    }

    function _seedrand(bytes memory seed) public pure returns (Seed memory randseed) {
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

    function _rand(Seed memory randseed) public pure returns (uint256 rnd) {
        unchecked {
            int32 t = randseed.s0 ^ int32(randseed.s0 << 11);
            randseed.s0 = randseed.s1;
            randseed.s1 = randseed.s2;
            randseed.s2 = randseed.s3;
            randseed.s3 = randseed.s3 ^ (randseed.s3 >> 19) ^ t ^ (t >> 8);
            rnd = uint32(randseed.s3);
        }
    }

    function _randhsl(Seed memory randseed)
        public
        pure
        returns (
            uint16 hue,
            uint8 saturation,
            uint8 lightness
        )
    {
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

    function _setColor(
        bytes memory metadata,
        Seed memory randseed,
        uint8 i
    ) public pure returns (bytes memory) {
        (uint16 hue, uint8 saturation, uint8 lightness) = _randhsl(randseed);
        uint256 pos = COLOR_BG_POS;
        if (i == 1) {
            pos = COLOR_1_POS;
        } else if (i == 2) {
            pos = COLOR_2_POS;
        }
        metadata = _writeUint(metadata, pos + 0, hue);
        metadata = _writeUint(metadata, pos + 4, saturation);
        metadata = _writeUint(metadata, pos + 9, lightness);
        return metadata;
    }

    function _writeUintAsHex(
        bytes memory data,
        uint256 endPos,
        uint256 num
    ) public pure returns (bytes memory) {
        while (num != 0) {
            data[endPos--] = bytes1(hexAlphabet[num % 16]);
            num /= 16;
        }
        return data;
    }

    function _addressToString(address who) public pure returns (string memory) {
        bytes memory addr = "0x0000000000000000000000000000000000000000";
        addr = _writeUintAsHex(addr, 41, uint160(who));
        return string(addr);
    }

    function _setPixel(
        bytes memory metadata,
        uint256 x,
        uint256 y,
        uint8 color
    ) public pure returns (bytes memory) {
        uint256 pathPos = 0;
        if (color == 0) {
            return metadata;
        }
        if (color == 1) {
            pathPos = PATH_1_POS;
        } else if (color == 2) {
            pathPos = PATH_2_POS;
        }
        uint256 pos = pathPos + y * 5 + (y * 8 + x) * 12 + 8;
        metadata[pos] = "1";
        return metadata;
    }

    function renderSVG(address who) public pure returns (string memory) {
        bytes memory svg = SVG_TEMPLATE;

        Seed memory randseed = _seedrand(bytes(_addressToString(who)));

        svg = _setColor(svg, randseed, 1);
        svg = _setColor(svg, randseed, 0);
        svg = _setColor(svg, randseed, 2);

        for (uint256 y = 0; y < 8; y++) {
            uint8 p0 = uint8((_rand(randseed) * 23) / 2147483648 / 10);
            uint8 p1 = uint8((_rand(randseed) * 23) / 2147483648 / 10);
            uint8 p2 = uint8((_rand(randseed) * 23) / 2147483648 / 10);
            uint8 p3 = uint8((_rand(randseed) * 23) / 2147483648 / 10);

            svg = _setPixel(svg, 0, y, p0);
            svg = _setPixel(svg, 1, y, p1);
            svg = _setPixel(svg, 2, y, p2);
            svg = _setPixel(svg, 3, y, p3);
            svg = _setPixel(svg, 4, y, p3);
            svg = _setPixel(svg, 5, y, p2);
            svg = _setPixel(svg, 6, y, p1);
            svg = _setPixel(svg, 7, y, p0);
        }

        return string(svg);
    }
}
