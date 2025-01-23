// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


contract Decode{
    struct myStruct{
        string x;
        uint[2] ar;
    }
    function encode(uint x, address addr, uint[] calldata arr, myStruct memory structs) external pure returns(bytes memory) {
        return abi.encode(x,addr,arr,structs);
    }
    function decode(bytes memory inputBytes) public pure returns (uint x,address addr,uint[] memory arr,myStruct memory structs){
         (x,addr,arr,structs)=abi.decode(inputBytes,(uint,address,uint[],myStruct));

    }   
}