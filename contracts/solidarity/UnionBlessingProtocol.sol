// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnionBlessingProtocol {
    address public steward;
    mapping(address => bool) public unionMembers;
    mapping(address => uint256) public blessingScore;

    event UnionJoined(address member, string oath);
    event BlessingIssued(address member, uint256 score, string damayClause);

    constructor() {
        steward = msg.sender;
    }

    function joinUnion(address member) public {
        require(msg.sender == steward, "Only steward may induct");
        unionMembers[member] = true;
        emit UnionJoined(member, "Oath of Solidarity accepted. Stewardship begins.");
    }

    function issueBlessing(address member, uint256 score) public {
        require(unionMembers[member], "Not a union member");
        blessingScore[member] += score;
        emit BlessingIssued(member, score, "Damay clause honored. Union restored.");
    }

    function getBlessingScore(address member) public view returns (uint256) {
        return blessingScore[member];
    }
}
