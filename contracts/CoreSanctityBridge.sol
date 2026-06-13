// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CoreSanctityBridge
/// @notice Bridge covenant to connect sanctum of core behaviour with integrity chain
contract CoreSanctityBridge {
    address public oversightCommittee;
    uint256 public bridgeCount;

    struct SanctityRecord {
        uint256 id;
        string domain;     // e.g. tech, creative, governance
        string sanctity;   // clean, aligned, protected
        string link;       // integrity chain reference
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => SanctityRecord) public records;

    event SanctityLinked(uint256 indexed id, string domain, string sanctity, string link, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight links sanctity record to integrity chain
    function linkSanctity(string calldata domain, string calldata sanctity, string calldata link, string calldata notes) external onlyOversight {
        bridgeCount++;
        records[bridgeCount] = SanctityRecord({
            id: bridgeCount,
            domain: domain,
            sanctity: sanctity,
            link: link,
            notes: notes,
            timestamp: block.timestamp
        });
        emit SanctityLinked(bridgeCount, domain, sanctity, link, notes);
    }

    /// @notice Citizens can view sanctity records
    function viewSanctity(uint256 id) external view returns (SanctityRecord memory) {
        return records[id];
    }
}
