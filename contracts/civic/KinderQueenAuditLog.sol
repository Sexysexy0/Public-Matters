// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract KinderQueenAuditLog {
    address public steward;
    mapping(address => bool) public kinderQueens;

    struct AuditEntry {
        string action;
        string projectName;
        string contractor;
        string emotionalTag;
        address queen;
        uint256 timestamp;
    }

    AuditEntry[] public logs;

    event AuditLogged(string action, string projectName, string contractor, address queen);

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

    function logAudit(
        string memory action,
        string memory projectName,
        string memory contractor,
        string memory emotionalTag
    ) public onlyQueen {
        logs.push(AuditEntry(action, projectName, contractor, emotionalTag, msg.sender, block.timestamp));
        emit AuditLogged(action, projectName, contractor, msg.sender);
    }

    function getAudit(uint256 index) public view returns (AuditEntry memory) {
        return logs[index];
    }

    function totalAudits() public view returns (uint256) {
        return logs.length;
    }
}
