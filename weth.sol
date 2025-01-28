// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@rari-capital/solmate/src/tokens/ERC20.sol";

contract Weth is ERC20{
    constructor() ERC20("Wraaped ether","weth",16){

    }
    fallback() external payable {
        deposit();
    }
    function deposit() public payable {
        _mint(msg.sender,msg.value);

    }
    function withdraw(uint _amount) external {
        _burn(msg.sender,_amount);
        payable(msg.sender).transfer(_amount);
    }
}   