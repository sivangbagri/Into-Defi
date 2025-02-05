// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./erc20.sol";

contract CSMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint256 public reserve0; // quantity
    uint256 public reserve1;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address to, uint256 _amount) public {
        totalSupply += _amount;
        balanceOf[to] += _amount;
    }

    function _burn(address from, uint256 _amount) public {
        totalSupply -= _amount;
        balanceOf[from] -= _amount;
    }
    function _update(uint _res0, uint _res1) private{
        reserve0=_res0;
        reserve1=_res1;
    }
    function swap(address _tokenIn, uint256 _amountIn)
        external
        returns (uint256 amountOut)
    {
        require(
            _tokenIn == address(token1) || _tokenIn == address(token0),
            "Invalid token"
        );
        // transfer token in
        uint256 amountIn;
        if (_tokenIn == address(token0)) {
            token0.transferFrom(msg.sender, address(this), _amountIn);
            amountIn = token0.balanceOf(address(this)) - reserve0;
        } else {
            token1.transferFrom(msg.sender, address(this), _amountIn);
            amountIn = token0.balanceOf(address(this)) - reserve1;
        }
        // calculate amountOut (+ fees 0.3%)
        amountOut= (amountIn*997)/100;
        if(_tokenIn == address(token0)) {
            _update(reserve0+_amountIn,reserve1-amountOut);
        } else {
            _update(reserve0-amountOut,reserve1+_amountIn);
             
         }
        // token trnasfer out
        if(_tokenIn == address(token0)) {
            token1.transfer(msg.sender,amountOut);
         } else {
            token0.transfer(msg.sender,amountOut);
         }

    }

    function addLiquidity(uint _amount0, uint _amount1) external {
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        uint bal0=token0.balanceOf(address(this));
        uint bal1=token1.balanceOf(address(this));

        uint d0= bal0-reserve0;
        uint d1= bal1-reserve1;

        // share transfer 
        uint shares;
        if(totalSupply==0){
            shares=d0+d1;
        } else{
            shares=((d0+d1)*totalSupply)/(reserve0+reserve1); 
        }
        require(shares>0,"shares 0");
        _mint(msg.sender,shares);
        _update(bal0,bal1);

    }

    function removeLiquidity(uint _shares) external returns(uint d0, uint d1){
        d0=(_shares*(reserve0))/totalSupply;
        d1=(_shares*(reserve1))/totalSupply;
        _burn(msg.sender,_shares);
        _update(reserve0-d0,reserve1-d1);
        if(d0>0){token0.transfer(msg.sender, d0);}
        if(d1>0){token1.transfer(msg.sender, d1);}


    }
}
