// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract FunctionModifier{
    bool public paused;
    uint public count;

    function setPause(bool _paused) external {
        paused=_paused;
    }
    modifier whenNotPaused(){
        require(!paused,"It is Paused");
        _; // placehiolder for function
    }
    function inc() external whenNotPaused{
        count+=1;
    }
    modifier cap(uint _x) {
        require(_x<100,"only less then 100 allowed");
        _;
    }

    function incBy(uint _x) external cap(_x){
        count+=_x;
    }
    ////////
    uint public maxLimit = 50;

    modifier withinLimit(uint _limit) {
        require(_limit < 100, "Limit must be less than 100");
        _;
    }

    function updateLimit(uint newLimit) external withinLimit(maxLimit) {
        maxLimit = newLimit;
    }
}