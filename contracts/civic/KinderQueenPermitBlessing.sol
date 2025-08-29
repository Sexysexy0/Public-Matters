// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract KinderQueenPermitBlessing {
    address public steward;
    mapping(address => bool) public kinderQueens;

    struct Permit {
        string contractor;
        string projectName;
        bool emotionallyApproved;
        bool damayClauseVerified;
        bool blessed;
        address queen;
        uint256 timestamp;
    }

    Permit[] public permits;

    event PermitBlessed(string contractor, string projectName, address queen);

    modifier onlyQueen() {
        require(kinderQueens[msg.sender], "Not a Kinder Queen");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerQueen(address queen) public {
        require(msg.sender == steward, "Only steward may register queens");
        kinderQueens[queen] = true;
    }

    function blessPermit(
        string memory contractor,
        string memory projectName,
        bool emotionallyApproved,
        bool damayClauseVerified
    ) public onlyQueen {
        permits.push(Permit(contractor, projectName, emotionallyApproved, damayClauseVerified, true, msg.sender, block.timestamp));
        emit PermitBlessed(contractor, projectName, msg.sender);
    }

    function getPermit(uint256 index) public view returns (Permit memory) {
        return permits[index];
    }

    function totalPermits() public view returns (uint256) {
        return permits.length;
    }
}
