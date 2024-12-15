// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Output{

    function returnMany() public pure returns (uint, bool){
        return(1, true);
    }  
    function named() public pure returns (uint x, bool y){
        
        return (1,true);
    }
     function assigned() public pure returns (uint x, bool y){
        x=1;
        y=true; // saves a little bit of gas
        
    }
    function destruct() public pure  {
        (uint x,bool y)=returnMany();
        (,bool z)=returnMany();
    }


}