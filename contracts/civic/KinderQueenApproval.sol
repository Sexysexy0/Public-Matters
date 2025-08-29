// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract KinderQueenApproval {
    address public steward;
    mapping(address => bool) public approvedByKinderQueen;
    event ApprovalGranted(address indexed candidate, string reason);
    event ApprovalRevoked(address indexed candidate, string reason);

    constructor() {
        steward = msg.sender;
    }

    function grantApproval(address candidate, string memory reason) public {
        require(msg.sender == steward, "Only steward may grant approval");
        approvedByKinderQueen[candidate] = true;
        emit ApprovalGranted(candidate, reason);
    }

    function revokeApproval(address candidate, string memory reason) public {
        require(msg.sender == steward, "Only steward may revoke approval");
        approvedByKinderQueen[candidate] = false;
        emit ApprovalRevoked(candidate, reason);
    }

    function isApproved(address candidate) public view returns (bool) {
        return approvedByKinderQueen[candidate];
    }
}
