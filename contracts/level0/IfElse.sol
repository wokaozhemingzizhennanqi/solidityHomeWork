// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

contract IfElse{
    function test(uint value) public pure returns(uint){
        if(value<10){
            return 1;
        }else if(value<20){
            return 2;
        }else{
            return value < 30 ? 3 : 4;
        }
    }
}