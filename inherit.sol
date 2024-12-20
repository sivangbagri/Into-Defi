// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


contract A{
    function foo() external pure virtual returns ( string memory){
        return "A";
    }
}

contract B is A{
    function foo() external pure virtual override returns ( string memory){
        return "B";
    }

}

contract C is A,B{ // order matters here
    function foo() external pure override(A,B) returns ( string memory){
        return "C";
    }

}