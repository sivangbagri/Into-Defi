// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
// ERC-20 Interface
interface IERC20 {

    // Total token supply
    function totalSupply() external view returns (uint256);

    // Balance of a specific address
    function balanceOf(address account) external view returns (uint256);

    // Transfer tokens from the caller to another address
    function transfer(address recipient, uint256 amount) external returns (bool);

    // Allow an address to spend tokens on behalf of the owner
    function approve(address spender, uint256 amount) external returns (bool);

    // Check the remaining allowance
    function allowance(address owner, address spender) external view returns (uint256);

    // Transfer tokens on behalf of the owner
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20 is IERC20{
    uint public totalSupply;
    mapping(address=>uint) public balanceOf;
    mapping(address=>mapping(address=>uint)) public allowance; 
    string public name="test";
    string public symbol="TEST";
    uint8 public decimal=18;
   

    // Transfer tokens from the caller to another address
    function transfer(address recipient, uint256 amount) external returns (bool){
        balanceOf[msg.sender]-=amount;
        balanceOf[recipient]+=amount;
        emit Transfer(msg.sender,recipient,amount);
        return true;
    }

    // Allow an address to spend tokens on behalf of the owner
    function approve(address spender, uint256 amount) external returns (bool){
        allowance[msg.sender][spender]=amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }


    // Transfer tokens on behalf of the owner
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
        allowance[sender][msg.sender]-=amount;
        balanceOf[sender]-=amount;
        balanceOf[recipient]+=amount;
        emit Transfer( sender, recipient, amount);
        return true;
    }
    function mint(uint amount) external{ // create new token
        balanceOf[msg.sender]+=amount;
        totalSupply+=amount;
        emit Transfer(address(0), msg.sender, amount);
    }
    function burn(uint amount) external{ // destroy tokens
        balanceOf[msg.sender]-=amount;
        totalSupply-=amount;
        emit Transfer(msg.sender,address(0), amount);
    }

}