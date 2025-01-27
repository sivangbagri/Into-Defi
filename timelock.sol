// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


contract TimeLock{
    address public owner;
    mapping(bytes32=>bool) public queued;
    error TimeStampNotinRange(uint blockTimestamp,uint timestamp);

    uint public constant MIN=10;
    uint public constant MAX=1000; //seconds 
    uint public constant GRACE=1000; // 1000 seconds before txn expires

    constructor(){
        owner = msg.sender;
    }
    receive() external payable{}
    modifier onlyOwner(){
        require(msg.sender==owner,"Not owner");
        _;
    }
    function getTxId(address _target, uint _value,string calldata _func, bytes calldata _data,uint _timestamp) public pure returns(bytes32 txId) {
        txId=keccak256(abi.encode(_target,_value,_func,_data,_timestamp));
    }
    function queue(address _target, uint _value,string calldata _func, bytes calldata _data,uint _timestamp)  external onlyOwner{
        bytes32 txId= getTxId(_target, _value, _func, _data,_timestamp);
        require(queued[txId]==false,"Already Queued"); // checking for unique txID
        if(_timestamp<block.timestamp+MIN || _timestamp>block.timestamp +MAX){
            revert TimeStampNotinRange(block.timestamp,_timestamp);
        }
        queued[txId]=true;

    }
    function execute(address _target, uint _value,string calldata _func, bytes calldata _data,uint _timestamp) payable external onlyOwner returns(bytes memory){
        bytes32 txId= getTxId(_target, _value, _func, _data,_timestamp);
        require(queued[txId],"Not Queued yet");  
        require(block.timestamp>_timestamp,"Not waited min time");
        require(block.timestamp<_timestamp+GRACE,"TXN Expired");
        queued[txId]=false;
        bytes memory data;
        if(bytes(_func).length>0){
            data=abi.encode(bytes4(keccak256(bytes(_func))),_data);
        } else{
            data=_data;
        }
        (bool ok, bytes memory res)=_target.call{value:_value}(data);
        require(ok,"Execution failed");
        return res;
    }
    function cancel(bytes32 txId) external onlyOwner{
        require(queued[txId],"Not queued yet");
        queued[txId]=false;
    }

    

}

contract TestTimeLock{
    address public timelock;
    constructor(address _timelock){
        timelock = _timelock;
    }
    function test() external view {
        require(msg.sender==timelock);
    }
    function getTimestamp() external view returns(uint)  {
        return block.timestamp+30;
    }
}