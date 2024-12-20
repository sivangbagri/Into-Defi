// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;



contract S{
    string public name;
    constructor(string memory _name){
        name=_name;
    }

}
contract T{
    string public txt;
    constructor(string memory _text){
        txt=_text;
    }

}
//order of execution of constructors : S -> T -> U 
contract U is S("me"), T{
    constructor(string memory _text) T(_text){

    }

}
