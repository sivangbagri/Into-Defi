// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract C {
    // address public owner; // adding this on top causes unexpected behaviour ;; orginal state variables order should be preserved 
    uint256 public num;
    address public sender;
    uint256 public value;
    // address public owner ; this is ok✅

    function setVars(uint256 _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract B {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(address _test, uint256 _num) external payable {
        // _test.delegatecall(abi.encodeWithSignature("setVars(uint256)",_num)); or
        (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSelector(C.setVars.selector, _num));
        require(success, "Call failed");
    }
}
