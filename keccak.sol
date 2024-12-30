// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Hash{
    function encode(string memory a, string memory b) external pure returns (bytes32){
        // return keccak256(abi.encode(a,b)); // or 
        return keccak256(abi.encodePacked(a,b)); // causes hash collision 
            // 256bit/ 32 bytes( bytes);  
    }
}