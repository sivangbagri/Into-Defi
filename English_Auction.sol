// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _nftId
    ) external;
}

contract English{
    IERC721 public nft;
    uint public immutable nftId;
    address payable public  immutable seller;
    uint32 public endAt; //timestamp
    bool public started;
    bool public ended;
    address public highestBidder;
    uint public highestBid;
    mapping(address=>uint) public bids;
    event Start();
    event Bid(address indexed  bidder,uint amount);
    constructor(address _nft, uint _nftId, uint _startingBid){
        nft=IERC721(_nft);
        nftId=_nftId;
        highestBid=_startingBid;
        seller=payable(msg.sender);

    }
    modifier onlySeller(){
        require(msg.sender==seller,"Not authorized");
        _;
    }
    function start() external onlySeller{
         require(!started,"Already started");
         started=true;
         endAt=uint32(block.timestamp+60); // 60 sec
         nft.transferFrom(seller, address(this), nftId);
         emit Start();

    }
    function bid() external payable{
        require(started,"Not started yet");
        require(block.timestamp<endAt,"Ended");
        require(msg.value>highestBid,"You have to bid more than the current highest bidding amount");
        if(highestBidder!=address(0)){
            bids[highestBidder]+=highestBid;
        }
        highestBid=msg.value;
        highestBidder=msg.sender;
        emit Bid(msg.sender, msg.value);
        

    }  
    function withdraw() external{
        uint bal=bids[msg.sender];
        bids[msg.sender]=0;
        payable(msg.sender).transfer(bal);
    }
    function end() external{
        require(started,"Not started yet");
        require(!ended,"Already ended");
        require((block.timestamp>=endAt),"Ending time not passed yet");
        ended=true;
        if(highestBidder!=address(0)){
            nft.transferFrom(address(this),highestBidder,nftId);
            seller.transfer(highestBid);
        }
        else{
            nft.transferFrom(address(this),seller,nftId);
        }
    }
       

}