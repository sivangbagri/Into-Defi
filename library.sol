// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

library Sum{
    function add(uint a, uint b) internal pure returns(uint){
        return (a+b);
    }
}

contract Test{
    using Sum for uint;
    function testAdd(uint a, uint b) external pure returns (uint) {
        // return Sum.add(a,b); // or 
        return a.add(b);
    }

}