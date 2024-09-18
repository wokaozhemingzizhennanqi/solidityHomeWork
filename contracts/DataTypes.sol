// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract DataTypes{
    bool public _bool=true;

    // uintN range 0 to 2 ** N -1
    uint8 public _uint8=2 ** 8 -1;

    // intN range -2 ** (N-1)  to 2 ** (N-1) -1
    int8 public _int8 = 2 ** (8-1) - 1;

    address public addr=0x1234567890123456789012345678901234567890;

    bytes1 _byte1 = 0xaa;


    function setIntValue(int8 value) public {
        _int8 = value;
    }
}