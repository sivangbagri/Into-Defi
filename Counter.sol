// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Counter {
    uint256 public x;

    function count() external view returns (uint256) {
        return x;
    }

    function inc() external {
        x += 1;
    }
}
