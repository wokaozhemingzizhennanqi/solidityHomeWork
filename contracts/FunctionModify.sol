// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract FunctionModify{
    uint8 state;

    constructor(uint8 inputState){
        state = inputState;
    }

    modifier onlyOwner(){
        require(state!=1,"state must not be one");
        _;
    }

    modifier  validState(uint8 _state){
        require(_state!=2,"state must not be two");
        _;
    }

    function changeState(uint8 _state) public onlyOwner validState(_state){
        state=_state;
    }
}