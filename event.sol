// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract events{
    event Log(string message, uint val);
    event IndexedLog(address indexed sender,uint val); // only 3 index allowed
    function example() external {
        emit Log("Hii",69);
        emit IndexedLog(msg.sender,789);
        

    }

}