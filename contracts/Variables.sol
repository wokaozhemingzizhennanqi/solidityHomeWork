// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract Variables{
    uint public  timestamp = block.timestamp;

    address public  sender = msg.sender;

    function localValue() public {
       timestamp = block.timestamp;
        
    }
}