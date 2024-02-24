// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract HashToCurve {
    // Example Elliptic Curve parameters (y^2 = x^3 + ax + b)
    uint256 constant public a = 0;
    uint256 constant public b = 7;
    uint256 constant public p = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
    uint256 constant public n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
    uint256 constant public Gx = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
    uint256 constant public Gy = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;

    // Hash to Curve function
    function hashToCurve(bytes32 hash) public view returns (uint256 x, uint256 y) {
        uint256 t = uint256(hash);
        while(true) {
            x = t % p;
            y = sqrt((x**3 + a*x + b) % p);
            if(y != 0) {
                return (x, y);
            }
            t++;
        }
    }

    // Modulo square root function
    function sqrt(uint256 x) internal view returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}
