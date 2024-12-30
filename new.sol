// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Acount{
    address public bank;
    address public owner;

    constructor(address _owner) payable{
        bank=msg.sender;
        owner=_owner;
    }
}

contract AccountFactory{
    Acount[] public accounts;
    function createAccount(address _owner) external payable{
        Acount account = new Acount{value:111}(_owner);
        accounts.push(account);

    }
}