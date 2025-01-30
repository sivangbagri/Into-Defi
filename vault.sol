// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./erc20.sol";
contract Vault{
    IERC20 public immutable token;
    uint public totalSupply;
    mapping (address=>uint)public balanceOf;
    constructor(address _token){
        token=IERC20(_token);
    }
    function _mint(address to,uint _amount) public {
        totalSupply+=_amount;
        balanceOf[to]+=_amount;
    }
    function _burn(address from,uint _amount) public {
        totalSupply-=_amount;
        balanceOf[from]-=_amount;
    }
    function deposit(uint _amount) external {
        uint shares;
        if(totalSupply==0){
            shares=_amount;
        } else{
            shares=(_amount*totalSupply)/(token.balanceOf(address(this))); // 
        }
        _mint(msg.sender,shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }
    function withdraw(uint shares) external {
        uint amount=(shares*token.balanceOf(address(this)))/totalSupply;
        _burn(msg.sender,shares);
        token.transfer(msg.sender, amount); // 
    }

}