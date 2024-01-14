// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Platform {

    // constructor(address initialOwner) Ownable(initialOwner) {}

    event NewListing(address owner, ListingInfo info);

 
    struct ListingInfo {
        address poster;
        address collectionAddr;
        uint256 tokenId;
        uint256 amount;
        uint256 duration;
        uint256 APR;
        bytes32 status;
    }

    mapping(uint256 => ListingInfo) public listNum;
    mapping(address => uint256[]) addrList;

    uint256 counter;

    function getListing(address addr) public view returns (uint256[] memory) {
        return addrList[addr];
    }

    function getMyListing() public view returns (uint256[] memory) {
        return addrList[msg.sender];
    }

    function getListingInfo(uint256 num) public view returns (ListingInfo memory) {
        return listNum[num];
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }

    function balanceNFT(address collectionAddr) public view returns (uint256) {
        return IERC721(collectionAddr).balanceOf(msg.sender);
    }

    function ownerOf(address collectionAddr, uint256 tokenId) public view returns (address) {
        return IERC721(collectionAddr).ownerOf(tokenId);
    }

    function cancelApproveAll(address collectionAddr, address to) public {
        IERC721(collectionAddr).setApprovalForAll(to, false);
    }

    function approveAll(address collectionAddr, address to) public {
        IERC721(collectionAddr).setApprovalForAll(to, true);
    }

    function approveAllToContract(address collectionAddr) public {
        IERC721(collectionAddr).setApprovalForAll(address(this), true);
    }

    function isApprove(address collectionAddr, address to) public view returns (bool) {
        return IERC721(collectionAddr).isApprovedForAll(msg.sender, to);
    }

    function isApprove2(address collectionAddr, address to) public view returns (bool) {
        return IERC721(collectionAddr).isApprovedForAll(to, msg.sender);
    }

    function safeTransferFrom(address collectionAddr, address to, uint256 tokenId) public {
        IERC721(collectionAddr).safeTransferFrom(msg.sender, to, tokenId);
    }

    function openListing(
        address collectionAddr,
        uint256 tokenId,
        uint256 amount,
        uint256 duration,
        uint256 APR,
        address to
    ) public {
        require(amount > 0 && duration > 0 && APR > 0, "Values must be greater than zero");

        ListingInfo memory info = ListingInfo(msg.sender, collectionAddr, tokenId, amount, duration, APR, "Open");
        listNum[counter] = info;
        addrList[msg.sender].push(counter);
        ++counter;

        IERC721(collectionAddr).transferFrom(msg.sender, to, tokenId);

        emit NewListing(msg.sender, info);
    }
}



contract NFTOwner {
    IERC721 public nftContract;
    address public depositContract;

    constructor(address _nftContract, address _depositContract) {
        nftContract = IERC721(_nftContract);
        depositContract = _depositContract;
    }

    function approveAndDeposit(uint256 tokenId) public {
        // NFT를 예치 컨트랙트에 권한 부여
        nftContract.approve(depositContract, tokenId);

        // NFT를 예치 컨트랙트로 이동 (여기서는 예치 컨트랙트의 depositNFT 함수를 호출해야 함)
        // 이 부분은 예치 컨트랙트의 구현에 따라 달라질 수 있습니다.
    }
}