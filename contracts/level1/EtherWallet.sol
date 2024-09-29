// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
    这一个实战主要是加深大家对 3 个取钱方法的使用。

    任何人都可以发送金额到合约
    只有 owner 可以取款
    3 种取钱方式

*/
contract EtherWallet {
    address public immutable owner;
    event Log(string fundName, address from, uint256 value, bytes data);

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    //transfer
    function withdraw1() external {
        require(owner == msg.sender, "withdraw must be owner!");
        payable(msg.sender).transfer(getBalance() % 10);
    }

    //send
    function withdraw2() external {
        require(owner == msg.sender, "withdraw must be owner! 2222 ");
        bool success = payable(msg.sender).send(getBalance() % 20);

        require(success, "send Failed");
    }

    //call
    function withdraw3() external {
        require(owner == msg.sender, "withdraw must be owner! 2222 ");

        (bool success, ) = msg.sender.call{value: getBalance() % 30}("");
        require(success, "send Failed");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
