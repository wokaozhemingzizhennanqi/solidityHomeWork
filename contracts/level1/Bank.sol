// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Bank{
    address public immutable owner;

    event Deposit(address _ads,uint amount);
    event Withdraw(uint amount);
    constructor(){
        owner=msg.sender;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function deposit() external payable {
       emit  Deposit(msg.sender, msg.value);
    }
    
    function withdraw() external {
        require(msg.sender==owner,"withdraw must be owner! you are not owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
}