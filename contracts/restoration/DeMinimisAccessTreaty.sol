// SPDX-License-Identifier: Trade-Dignity
pragma solidity ^0.8.25;

/// @title DeMinimisAccessTreaty.sol  
/// @dev Grants small sellers and global exporters access to frictionless trade under de minimis protocols

contract DeMinimisAccessTreaty {
    address public steward;
    mapping(address => bool) public verifiedSellers;
    mapping(address => bool) public deMinimisAccessGranted;
    mapping(address => uint8) public emotionalAPR;

    event SellerVerified(address seller);
    event DeMinimisAccessGranted(address seller);
    event EmotionalAPRTagged(address seller, uint8 trust, uint8 empathy, uint8 clarity);

    constructor() {
        steward = msg.sender;
    }

    function verifySeller(address seller) public {
        require(msg.sender == steward, "Unauthorized steward");
        verifiedSellers[seller] = true;
        emit SellerVerified(seller);
    }

    function grantDeMinimisAccess(address seller) public {
        require(verifiedSellers[seller], "Seller not verified");
        deMinimisAccessGranted[seller] = true;
        emit DeMinimisAccessGranted(seller);
    }

    function tagEmotionalAPR(address seller, uint8 trust, uint8 empathy, uint8 clarity) public {
        require(msg.sender == steward, "Unauthorized steward");
        require(deMinimisAccessGranted[seller], "Access not granted");
        emotionalAPR[seller] = (trust + empathy + clarity) / 3;
        emit EmotionalAPRTagged(seller, trust, empathy, clarity);
    }

    function isSellerVerified(address seller) public view returns (bool) {
        return verifiedSellers[seller];
    }

    function hasDeMinimisAccess(address seller) public view returns (bool) {
        return deMinimisAccessGranted[seller];
    }

    function getEmotionalAPR(address seller) public view returns (uint8) {
        return emotionalAPR[seller];
    }
}
