// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract FirstApp{
    uint public count;

    function selectCount() public view  returns(uint){
        return count;
    }

    function increment() public {
        count++;
    }

    function decrement()public {
        count--;
    }
}