// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract DeployByCreate2{
    address public owner;
    constructor(address _owner){
        owner=_owner;

    }
// new address=keccak256(0xFF∥deployer address∥salt∥keccak256 bytecode )[12:]

}
contract Create2Factory{
    event Deploy(address addr);
    function deploy(uint _salt) external {
        DeployByCreate2 _contract= new DeployByCreate2{salt:bytes32(_salt)}(msg.sender);
        emit Deploy(address(_contract));
    }
    function getAddress(bytes memory bytecode,uint _salt) public view returns(address){
        bytes32 hash= keccak256(abi.encodePacked(bytes1(0xff),address(this),_salt,keccak256(bytecode)));
        return address(uint160(uint(hash))); //since Ethereum addresses are 160-bit values
    }
    function getByteCode(address _owner) public pure returns (bytes memory){
        bytes memory bytecode= type(DeployByCreate2).creationCode;
        return abi.encodePacked(bytecode,abi.encode(_owner));
    }
}
