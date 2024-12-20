// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Fallback {
    event Log(string func, address sender, uint256 val);

    fallback() external payable {
        emit Log("fallback", msg.sender, 1);
    }

    receive() external payable {
        emit Log("receive", msg.sender, 1);
    }
}
