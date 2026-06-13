// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DomainBalanceCodex
/// @notice Codex covenant to document balance of core domains and habit alignment
contract DomainBalanceCodex {
    address public oversightCommittee;
    uint256 public codexCount;

    struct DomainRecord {
        uint256 id;
        string domain;     // e.g. tech, creative, governance
        string balance;    // clean, aligned, drift
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => DomainRecord) public records;

    event DomainLogged(uint256 indexed id, string domain, string balance, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs domain balance
    function logDomain(string calldata domain, string calldata balance, string calldata notes) external onlyOversight {
        codexCount++;
        records[codexCount] = DomainRecord({
            id: codexCount,
            domain: domain,
            balance: balance,
            notes: notes,
            timestamp: block.timestamp
        });
        emit DomainLogged(codexCount, domain, balance, notes);
    }

    /// @notice Citizens can view domain records
    function viewDomain(uint256 id) external view returns (DomainRecord memory) {
        return records[id];
    }
}
