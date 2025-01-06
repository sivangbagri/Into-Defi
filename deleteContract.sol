// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Kill{
    constructor() payable{}
    function kill() external{
        selfdestruct(payable(msg.sender)); // selfdestruct force send ether 
    }
    function test() external pure returns(uint){
        return 321;
    }
}

contract Helper{ // receives ether without any fallback function
    function getBalance() view external returns(uint){
        return address(this).balance;
    }
    function kill(Kill _kill) external{
        _kill.kill();
    }
}