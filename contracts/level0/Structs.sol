// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract Structs {
    struct Obj {
        string text;
        bool completed;
    }

    Obj[] public objList;

    function create(string calldata text, bool completed) public {
        objList.push(Obj(text, completed));
    }

    function get(uint256 index) public view returns (Obj memory) {
        return objList[index];
    }

    function update(uint256 index, string calldata text) public {
        Obj storage o = objList[index];
        o.completed = !o.completed;
        o.text = text;
    }
}
