// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
pragma abicoder v2;

// Point representation in affine form
struct Point {
    uint256 x;
    uint256 y;
}

/**
 * @dev BabyJubJub curve operations
 */
library BabyJubJub {
    // Curve parameters
    // E: A^2 + y^2 = 1 + Dx^2y^2 (mod Q)
    uint256 internal constant A = 168700;
    uint256 internal constant D = 168696;
    uint256 internal constant Q = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    uint256 internal constant H = 10944121435919637611123202872628637544274182200208017171849102093287904247808; // H=(Q+1)/2
    uint256 internal constant R = 2736030358979909402780800718157159386076813972158567259200215660948447373041;

    /**
     * @dev Default generator
     */
    function generator() internal pure returns (Point memory) {
        return
            Point({
                x: 16540640123574156134436876038791482806971768689494387082833631921987005038935,
                y: 20819045374670962167435360035096875258406992893633759881276124905556507972311
            });
    }

    /**
     * @dev Add 2 points on BabyJubJub curve
     * Formulae for adding 2 points on a twisted Edwards curve:
     * x3 = (x1y2 + y1x2) / (1 + dx1x2y1y2)
     * y3 = (y1y2 - ax1x2) / (1 - dx1x2y1y2)
     * @param _point1 first point
     * @param _point2 second point
     * @return resulting point
     */
    function add(Point memory _point1, Point memory _point2) internal view returns (Point memory) {
        uint256 x1x2 = mulmod(_point1.x, _point2.x, Q);
        uint256 y1y2 = mulmod(_point1.y, _point2.y, Q);

        uint256 dx1x2y1y2 = mulmod(D, mulmod(x1x2, y1y2, Q), Q);

        uint256 x3Num = addmod(mulmod(_point1.x, _point2.y, Q), mulmod(_point1.y, _point2.x, Q), Q);
        uint256 y3Num = submod(y1y2, mulmod(A, x1x2, Q));

        return
            Point({
                x: mulmod(x3Num, invmod(addmod(1, dx1x2y1y2, Q)), Q),
                y: mulmod(y3Num, invmod(submod(1, dx1x2y1y2)), Q)
            });
    }

    /**
     * @dev Double a point on BabyJubJub curve
     * @param _p point to double
     * @return doubled point
     */
    function double(Point memory _p) internal view returns (Point memory) {
        return add(_p, _p);
    }

    /**
     * @dev Multiply a BabyJubJub point by a scalar
     * Use the double and add algorithm
     * @param _point point be multiplied by a scalar
     * @param _scalar scalar value
     * @return resulting point
     */
    function scalarMultiply(Point memory _point, uint256 _scalar) internal view returns (Point memory) {
        // Initial scalar remainder
        uint256 remaining = _scalar % R;

        // Copy initial point so that we don't mutate it
        Point memory initial = _point;

        // Initialize result
        Point memory result = Point({x: 0, y: 1});

        // Loop while remainder is greater than 0
        while (remaining != 0) {
            // If the right-most binary digit is 1 (number is odd) add initial point to result
            if ((remaining & 1) != 0) {
                result = add(result, initial);
            }

            // Double initial point
            initial = double(initial);

            // Shift bits to the right
            remaining = remaining >> 1;
        }

        return result;
    }

    /**
     * @dev Subtract a BabyJubJub point from another BabyJubJub point
     * @param _point1 the point which will be subtracted from
     * @param _point2 point to subtract
     * @return result
     */
    function subtract(Point memory _point1, Point memory _point2) internal view returns (Point memory) {
        return add(_point1, negate(_point2));
    }

    /**
     * @dev Negate a BabyJubJub point
     * @param _point point to negate
     * @return p = -(_p)
     */
    function negate(Point memory _point) internal pure returns (Point memory) {
        return Point({x: Q - _point.x, y: _point.y});
    }

    /**
     * @dev Check if a BabyJubJub point is on the curve
     * (168700x^2 + y^2) = (1 + 168696x^2y^2)
     * @param _point point to check
     * @return is on curve
     */
    function isOnCurve(Point memory _point) internal pure returns (bool) {
        uint256 xSq = mulmod(_point.x, _point.x, Q);
        uint256 ySq = mulmod(_point.y, _point.y, Q);

        uint256 lhs = addmod(mulmod(A, xSq, Q), ySq, Q);
        uint256 rhs = addmod(1, mulmod(mulmod(D, xSq, Q), ySq, Q), Q);

        return submod(lhs, rhs) == 0;
    }

    /**
     * @dev Modular subtract (mod n).
     * @param _a The first number
     * @param _b The number to be subtracted
     * @return result
     */
    function submod(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return addmod(_a, Q - _b, Q);
    }

    /**
     * @dev Compute modular inverse of a number
     * @param _a the value to be inverted in mod Q
     */
    function invmod(uint256 _a) internal view returns (uint256) {
        // We can use Euler's theorem instead of the extended Euclidean algorithm
        // Since m = Q and Q is prime we have: a^-1 = a^(m - 2) (mod m)
        return expmod(_a, 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffffff);
    }

    /**
     * @dev Exponentiation modulo Q
     * @param _base the base of the exponentiation
     * @param _exponent the exponent
     * @return result
     */
    function expmod(uint256 _base, uint256 _exponent) internal view returns (uint256) {
        uint256 result;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            let localQ := 0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001
            let memPtr := mload(0x40)
            mstore(memPtr, 0x20) // Length of base _b
            mstore(add(memPtr, 0x20), 0x20) // Length of exponent _e
            mstore(add(memPtr, 0x40), 0x20) // Length of modulus Q
            mstore(add(memPtr, 0x60), _base) // Base _b
            mstore(add(memPtr, 0x80), _exponent) // Exponent _e
            mstore(add(memPtr, 0xa0), localQ) // Modulus Q

            // The bigModExp precompile is at 0x05
            let success := staticcall(gas(), 0x05, memPtr, 0xc0, memPtr, 0x20)
            switch success
            case 0 {
                revert(0x0, 0x0)
            }
            default {
                result := mload(memPtr)
            }
        }

        return result;
    }

    /**
     * @dev Calculates square root of x^2 in BabyJubJub modulous using Tonelli-Shanks
     * @param _a the number to calculate its square root
     * @return result
     */
    function sqrtmod(uint256 _a) internal view returns (uint256 result) {
        // S is Q-1 without trailing zeros
        // N is the non-square number in ZZ_Q
        result = expmod(_a, 0x183227397098D014DC2822DB40C0AC2E9419F4243CDCB848A1F0FACA0); // x = _x2 ^ (S+1)/2
        uint256 b = expmod(_a, 0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F); // b = _x2 ^ S
        uint256 g = 0x2A3C09F0A58A7E8500E0A7EB8EF62ABC402D111E41112ED49BD61B6E725B19F0; // g = N ^ S
        uint256 t;
        uint16 r = 28; // number of trailing zeros in Q-1
        uint16 m;
        while (true) {
            m = 0;
            t = b;
            while (t != 1) {
                t = mulmod(t, t, Q);
                m++;
            }

            if (m == 0) {
                return result;
            }

            t = g;
            for (uint16 i; i < (r - m - 1); i++) {
                t = mulmod(t, t, Q);
            } // t = g^(2^(r-m-1)) mod Q

            g = mulmod(t, t, Q); // g = g^(2^(r-m)) mod Q
            result = mulmod(t, result, Q); // x = x * t mod Q
            b = mulmod(b, g, Q); // b = b * g mod Q
            r = m;
        }
    }
}
