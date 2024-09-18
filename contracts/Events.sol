// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract Events {
    event Log(address send, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}
