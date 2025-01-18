// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "./erc20.sol";
contract CrowdFund{
    struct Campaign{
        address creator;
        uint32 startAt;
        uint32 endAt;
        uint pledged;
        uint goal;
        bool claimed;

    }
    IERC20 public immutable token;
    uint public count;
    mapping(uint=>Campaign) public campaigns;
    mapping(uint=>mapping(address=>uint)) public pledgedAmount;
    constructor(address _token){
        token=IERC20(_token);
    }
    // stakeholder -> abilties -> properties -> data structure  -> function ->  constraints 
    function launch(uint _goal,uint32 _startAt, uint32 _endAt) external {
        require(_startAt>=block.timestamp,"start after now ");
        require(_endAt>_startAt,"Start before end");
        require(_endAt< block.timestamp+20 days,"End after 20 days only");
        count+=1;
        campaigns[count]=Campaign({creator:msg.sender,goal:_goal,startAt:_startAt,endAt:_endAt,claimed:false,pledged:0});
        
    }
    function cancel(uint _id) external {
        Campaign memory camp = campaigns[_id];
        require(msg.sender==camp.creator,"Not ur campaign");
        require(block.timestamp<camp.startAt,"started");
        delete campaigns[_id];
    
    }
    function pledge(uint _id, uint _amount) external {
        Campaign memory camp = campaigns[_id];
        require(_amount>0,"Less than minimum");
        require(block.timestamp>camp.startAt,"Not started yet");
        require(block.timestamp<camp.endAt,"Ended already");
        // require(!camp.claimed,"Already claimed");
        camp.pledged+=_amount;
        pledgedAmount[_id][msg.sender]+=_amount;
        token.transferFrom(msg.sender,address(this),_amount);


    }
    function unpledge(uint _id , uint _amount) external{
        Campaign storage camp = campaigns[_id];
        require(_amount>0,"Less than minimum");
        require(block.timestamp>camp.startAt,"Not started yet");
        require(block.timestamp<camp.endAt,"Ended already");
        camp.pledged-=_amount;
        pledgedAmount[_id][msg.sender]-=_amount;
        token.transfer(msg.sender,_amount);

    }
    function claim(uint _id) external {
        Campaign storage camp = campaigns[_id];
        require(block.timestamp>camp.endAt,"Not ended yet");
        require(msg.sender==camp.creator,"Not ur campaign");
        require(!camp.claimed,"Already calimed");
        require(camp.pledged>=camp.goal,"Goal not reached cant claim meant to refund");

        camp.claimed=true;
        token.transfer(msg.sender,camp.pledged);


    }
    function refund(uint _id) external {
        Campaign storage camp = campaigns[_id];
        require(block.timestamp>camp.endAt,"Not ended yet");
        require(camp.pledged<camp.goal,"Goal reached already");
        uint bal=pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender]=0;
        token.transfer(msg.sender,bal);



    }    
}