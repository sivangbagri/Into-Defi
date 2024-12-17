// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ennums{
    enum Status {
        None, // default value // 0
        Pending, // 1 
        Shipped, // 2 
        Completed // 3
    }
    Status public status;
    struct Order{
        address buyer;
        Status status;
    }
    function get() external view returns (Status){
        return status;
    } 
    function set(Status _status) external{
        status=_status;
    }
    function ship() external{
        status = Status.Shipped;
    }
    function reset() external{
        delete status;
    }
}