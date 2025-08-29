// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract QueenLedgerManifesto {
    address public steward;
    mapping(address => bool) public kinderQueens;

    struct LedgerEntry {
        string action;
        string projectName;
        string contractor;
        string emotionalTag;
        string damayClause;
        address queen;
        uint256 timestamp;
    }

    LedgerEntry[] public ledger;

    event LedgerUpdated(string action, string projectName, string contractor, address queen);

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

    function updateLedger(
        string memory action,
        string memory projectName,
        string memory contractor,
        string memory emotionalTag,
        string memory damayClause
    ) public onlyQueen {
        ledger.push(LedgerEntry(action, projectName, contractor, emotionalTag, damayClause, msg.sender, block.timestamp));
        emit LedgerUpdated(action, projectName, contractor, msg.sender);
    }

    function getLedgerEntry(uint256 index) public view returns (LedgerEntry memory) {
        return ledger[index];
    }

    function totalEntries() public view returns (uint256) {
        return ledger.length;
    }
}
