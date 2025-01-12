// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _nftId
    ) external;
}

contract Dutch {
    uint256 public constant DURATION = 7 days;
    IERC721 public immutable nft;
    uint256 public immutable nftId;
    address payable public immutable seller;
    uint256 public immutable startingPrice;
    uint256 public immutable startAt;
    uint256 public immutable expiresAt; //time
    uint256 public immutable discountRate;

    constructor( address _nft, uint256 _nftId, uint256 _startingPrice, uint256 _discountRate) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiresAt = startAt + DURATION;
        require(_startingPrice >= DURATION * _discountRate, "Insufficient starting amount");
        nft = IERC721(_nft);
        nftId = _nftId;
    }
    function getPrice() public view returns(uint){
        uint timeElapsed= block.timestamp-startAt;
        uint discount= discountRate*timeElapsed;
        return startingPrice-discount;

    }
    function buy() external payable{
        require(block.timestamp < expiresAt, "Dutch already ended");
        require (getPrice() <= msg.value, "Insufficient funds");
        nft.transferFrom(seller, msg.sender,nftId);
        uint refund=msg.value-getPrice();
         
        if(refund>0) {payable(msg.sender).transfer(refund);}
        selfdestruct(seller);
        

    }
}
