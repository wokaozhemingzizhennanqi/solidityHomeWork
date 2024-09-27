// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract Array {
    uint256[] public arr;
    uint256[] public arr2 = [1, 2, 3];

    function get(uint256 index, bool isArr) public view returns (uint256) {
        if (isArr) {
            return arr[index];
        } else {
            return arr2[index];
        }
    }

    function getArr(bool isArr) public view returns (uint256[] memory) {
        if (isArr) {
            return arr;
        } else {
            return arr2;
        }
    }

    function push(uint256 value, bool isArr) public {
        if (isArr) {
            return arr.push(value);
        } else {
            return arr2.push(value);
        }
    }

    function pop(bool isArr) public {
        if (isArr) {
            return arr.pop();
        } else {
            return arr2.pop();
        }
    }

    function getLength(bool isArr) public view returns (uint256) {
        if (isArr) {
            return arr.length;
        } else {
            return arr2.length;
        }
    }
}
