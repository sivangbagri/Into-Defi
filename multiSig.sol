// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public required; // # of approval required for trxn to be exe

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }
    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public approved; // is trxn ko is add ne appoves kiya ki nhi?

    constructor(address[] memory _owners, uint256 _required) {
        require(
            _required <= _owners.length && required > 0,
            "Invalid required"
        );
        require(_owners.length > 0, "No owners to create MultiSigWallet with");
        for (uint256 i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "Invalid address");
            require(!isOwner[_owners[i]], "Duplicate owner");
            isOwner[_owners[i]] = true;
            owners.push(_owners[i]);
        }
        required = _required;
    }

    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }
    modifier onlyOwner{
        require(isOwner[msg.sender], "Not owner");
        _;
    }
    function submit(address _to ,uint _value, bytes calldata data) external onlyOwner{
        transactions.push(Transaction(_to,_value,data,false));
        emit Submit(transactions.length-1);
    }
    modifier txExist(uint _txId){
        require(_txId < transactions.length, "Invalid txId");
        _;

    }
    modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender], "Already approved");
        _;
        
    }
    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed,"Already executed");
        _;
        
    }
    function approve(uint _txId) external onlyOwner txExist(_txId) notApproved(_txId) notExecuted(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }
    
    function getApprovalCount(uint _txId) private view returns(uint count){
        for(uint i=0;i<owners.length;i++){
            if(approved[_txId][owners[i]]){
                count++;
            }
        }

    }  
    function execute(uint _txId) external txExist(_txId) notExecuted(_txId) onlyOwner {
        require(getApprovalCount(_txId) >= required,"Not enough approvals");
        Transaction storage transaction = transactions[_txId];
        transaction.executed = true; 
        (bool success ,)=transaction.to.call{value:transaction.value}(transaction.data);
        require(success,"Failed");
        emit Execute(_txId);
    }    

    function revoke(uint _txId) external txExist(_txId) onlyOwner notExecuted(_txId){
        require(approved[_txId][msg.sender], "Not approved intially");
        approved[_txId][msg.sender]=false;
        emit Revoke(msg.sender, _txId);

    }
     
}
