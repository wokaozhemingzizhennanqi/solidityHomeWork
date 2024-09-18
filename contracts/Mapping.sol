// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract Mapping{
     mapping(address=> uint256) public _map;

    function get(address _addr) public  view  returns(uint256){
        return _map[_addr];
    }

    function set(address _addr,uint value) public {
        _map[_addr]=value;
    }

    function remove(address _addr) public {
        delete _map[_addr];
    }
}