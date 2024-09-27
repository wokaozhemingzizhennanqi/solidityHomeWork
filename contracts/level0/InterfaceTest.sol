// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

interface InterfaceTest{
    function val() external view returns(uint);

    function test() external;
}

contract CallBack{
    uint public val;

    fallback() external {
        val = InterfaceTest(msg.sender).val();
    }

    function test(address target) external{
        InterfaceTest(target).test();
    }
}

contract TestStorage{
    uint public val;
    function test() public {
        val=123;
        bytes memory b="";
        msg.sender.call(b);
    }
}


contract TestTransientStorage {
    bytes32 constant SLOT = 0;

    function test() public {
        assembly {
            tstore(SLOT, 321)
        }
        bytes memory b = "";
        msg.sender.call(b);
    }

    function val() public view returns (uint256 v) {
        assembly {
            v := tload(SLOT)
        }
    }
}

contract ReentrancyGuard {
    bool private locked;

    modifier lock() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    // 35313 gas
    function test() public lock {
        // Ignore call error
        bytes memory b = "";
        msg.sender.call(b);
    }
}

contract ReentrancyGuardTransient {
    bytes32 constant SLOT = 0;

    modifier lock() {
        assembly {
            if tload(SLOT) { revert(0, 0) }
            tstore(SLOT, 1)
        }
        _;
        assembly {
            tstore(SLOT, 0)
        }
    }

    // 21887 gas
    function test() external lock {
        // Ignore call error
        bytes memory b = "";
        msg.sender.call(b);
    }
}