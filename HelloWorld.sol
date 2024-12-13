 // SPDX-License-Identifier: MIT
pragma solidity 0.8.26; 

contract HelloWorld{
    string public myString ="Hello World" ;
    bool public a =true ;
    uint public x= 213; // uint === uint256 0 to 2**256 -1
    int public y = -12; // int === int256 -2**255 to 2**255-1
    address z;
    bytes32 public b32;

    function add(uint x1, uint x2) external pure returns (uint) {
        return x1+x2;
    }

    address sender = msg.sender;
    uint timestamp = block.timestamp;
    uint blockNum= block.number;
    
}