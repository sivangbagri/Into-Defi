// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns(bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    mapping(uint=>address) internal _ownerOf;
    mapping(address=>uint) internal _balanceOf; // # of nft
    mapping(uint=>address) internal _approvals; // nftID->approvedTO 
    mapping(address=>mapping(address=>bool)) public isApprovedForAll; // for all NFts;
    function supportsInterface(bytes4 interfaceID) external pure  returns(bool){
        return interfaceID==type(IERC721).interfaceId || interfaceID==type(IERC165).interfaceId;
    }
    function balanceOf(address _owner) external view returns (uint256){
        require(_owner!=address(0),"Zero address");
        return _balanceOf[_owner];
    }
    function ownerOf(uint256 _tokenId) external view returns (address owner){
        owner= _ownerOf[_tokenId];
        require(owner!=address(0),"No owner");
     }
    
    function setApprovalForAll(address _operator, bool _approved) external{
        require(_operator!=address(0),"Zero address");
        isApprovedForAll[msg.sender][_operator]=_approved;
    }
    function approve(address to, uint256 _tokenId) external payable{
        address owner=_ownerOf[_tokenId];
        require(msg.sender==owner || isApprovedForAll[owner][msg.sender],"not authorized");
        _approvals[_tokenId]=to;

        }

    function getApproved(uint256 _tokenId) external view returns (address){
        require(_ownerOf[_tokenId]!=address(0),"No token");
        return _approvals[_tokenId];
    }
    function _isApprovedorOwner( address owner,address spender, uint tokenId) internal view returns(bool){
        return(spender==owner || isApprovedForAll[owner][spender] || spender==_approvals[tokenId] );
    }
    function transferFrom(address _from, address _to, uint256 _tokenId) public payable{
        require(_from==_ownerOf[_tokenId],"u r not the owner");
        require(_to!=address(0),"zero add");
        require(_isApprovedorOwner(_from, msg.sender, _tokenId));
        _balanceOf[_from]--;
        _balanceOf[_to]++;
        _ownerOf[_tokenId]=_to;
        delete _approvals[_tokenId];


    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external payable{
        transferFrom(from,to,tokenId);
        require(to.code.length==0 || IERC721Receiver(to).onERC721Received(msg.sender,from,tokenId,"") == IERC721Receiver.onERC721Received.selector,"unsafe recipient");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external payable{
        transferFrom(from,to,tokenId);
        require(to.code.length==0 || IERC721Receiver(to).onERC721Received(msg.sender,from,tokenId,data) == IERC721Receiver.onERC721Received.selector,"unsafe recipient");
    }
    // function isApprovedForAll(address _owner, address _operator) external view returns (bool){}
    function _mint(address to, uint256 id) internal {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[id] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[id] = to;

     }

    function _burn(uint256 id) internal {
        address owner = _ownerOf[id];
        require(owner != address(0), "not minted");

        _balanceOf[owner] -= 1;

        delete _ownerOf[id];
        delete _approvals[id];

     }
}


    


contract MyNFT is ERC721 {
    function mint(address to, uint256 id) external {
        _mint(to, id);
    }

    function burn(uint256 id) external {
        require(msg.sender == _ownerOf[id], "not owner");
        _burn(id);
    }
}