// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract Variable {
    uint8 public age;

    function requireTest(uint8 _age) public {
        require(_age > 0, "age must be greater than 0");

        age = _age;
    }

        function assertTest(uint8 _age) public {
        assert(_age > 0);

        age = _age;
    }
}
