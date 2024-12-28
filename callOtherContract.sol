// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract CallTestContract { // proxy to TestContract
    // function setX(address _test,uint _x) external {
    //     TestContract(_test).setX(_x); // _test is address of TestContract
    // } or
    function setX(TestContract _test, uint256 _x) external {
        _test.setX(_x);
    }
    function setXandReceiveEther(TestContract _test, uint256 _x) external payable {
        _test.setXandReceiveEther{value:msg.value}(_x);
    }
}

contract TestContract {
    uint256 public x;
    uint256 public value = 123;

    function setX(uint256 _x) external {
        x = _x;
    }

    function setXandReceiveEther(uint256 _x) external payable {
        x = _x;
        value = msg.value;
    }
}
