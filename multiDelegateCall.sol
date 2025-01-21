// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract MultiDelegateCall{
    function multiDelegateCall(bytes[] calldata data) external returns(bytes[] memory results) {
        results = new bytes[](data.length);
        for(uint i = 0;i<data.length;i++){
             (bool success, bytes memory res) = address(this).delegatecall(data[i]);
             require(success,"Failed");
             results[i] = res;

        }

    }
}


contract Test is MultiDelegateCall{
    event Log(address caller, string func, uint i);
    function func1(uint x, uint y) external  {
        emit Log(msg.sender,"func1",x+y);

    }
    function func2() external returns(uint)  {
        emit Log(msg.sender,"func2",2);
        return 11;

    }
    function getData1(uint _x, uint _y) external pure returns (bytes memory){
        return abi.encodeWithSignature("func1(uint256,uint256)",_x,_y);

    }
    function getData2() external pure returns (bytes memory){
        return abi.encodeWithSignature("func2()");

    }
}