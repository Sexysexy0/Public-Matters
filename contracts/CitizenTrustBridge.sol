// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CitizenTrustBridge
/// @notice Bridge covenant to connect tax burden with visible public benefit
contract CitizenTrustBridge {
    address public overseer;
    uint256 public bridgeCount;

    struct TrustRecord {
        uint256 id;
        string burden;       // e.g. income tax, VAT
        string benefit;      // healthcare, education, infrastructure
        string safeguard;    // transparency, accountability, fairness
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => TrustRecord) public records;

    event TrustLinked(uint256 indexed id, string burden, string benefit, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer links tax burden to public benefit
    function linkTrust(string calldata burden, string calldata benefit, string calldata safeguard, string calldata notes) external onlyOverseer {
        bridgeCount++;
        records[bridgeCount] = TrustRecord({
            id: bridgeCount,
            burden: burden,
            benefit: benefit,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit TrustLinked(bridgeCount, burden, benefit, safeguard, notes);
    }

    /// @notice Citizens can view trust records
    function viewTrust(uint256 id) external view returns (TrustRecord memory) {
        return records[id];
    }
}
