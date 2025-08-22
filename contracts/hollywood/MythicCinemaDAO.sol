// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Mythic Cinema DAO
/// @notice A decentralized studio governed by creatives, stewards, and emotional resonance metrics
/// @author Scrollchain

contract MythicCinemaDAO {
    address public founder;
    mapping(address => bool) public members;
    string[] public approvedProjects;

    event MemberJoined(address member);
    event ProjectApproved(string title);

    constructor() {
        founder = msg.sender;
        members[msg.sender] = true;
    }

    function joinDAO(address newMember) public {
        require(members[msg.sender], "Only members can invite");
        members[newMember] = true;
        emit MemberJoined(newMember);
    }

    function approveProject(string memory title) public {
        require(members[msg.sender], "Only members can approve");
        approvedProjects.push(title);
        emit ProjectApproved(title);
    }

    function getApprovedProjects() public view returns (string[] memory) {
        return approvedProjects;
    }
}
