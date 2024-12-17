// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract mappings{
    mapping(address=>uint) public balances;
    mapping(address => mapping(address=>bool)) public isFriend;
    address public cont=address(this); // contract address
    function examples() external{
        balances[msg.sender]=123;
        uint x = balances[address(1)];
        delete balances[msg.sender] ;// 0
        
    
    }   
}