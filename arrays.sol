// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Arr{
    uint[] public nums=[1,2,3]; // dynamic size
    uint[3] public nums2=[12,3,3];
    function examples() external {
        nums.push(4); // [1,2,3,4]
        uint x= nums[1];
        nums[2]=89; // [1,2,89,4]
        delete nums[1]; // [1,0,89,4]

        // create array in memory
        uint[] memory a = new uint[](5);
        a[1]=33;
    }
        function returnArray() external view returns(uint[] memory){
            return nums;
        }
    

}