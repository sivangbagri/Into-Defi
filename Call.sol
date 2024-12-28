// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract TestCall {
    string public message;
    uint256 public x;

    event Log(string message);

    fallback() external payable {
        emit Log("fallback called");
    }

    function foo(string memory _message, uint256 _x)
        external
        payable
        returns (bool, uint256)
    {
        message = _message;
        x = _x;
        return (true, 999);
    }
}

contract Call {
    bytes public data;

    function callFoo(address _test) external payable {
        (bool success, bytes memory _data) = _test.call{value: 89}(
            abi.encodeWithSignature("foo(string,uint256)", "call foo", 123)
        ); // function sig , input params

        require(success, "Call failed");
        data = _data;
    }

    function callDoesNotExit(address _test) external {
        (bool success, ) = _test.call(
            abi.encodeWithSignature("doesNotExist()") // fallback will be executed
        );
        require(success, "Call failed");
    }
}
