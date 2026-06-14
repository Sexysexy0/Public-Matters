// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InnovationCommercializationBridge
/// @notice Bridge covenant to connect IP generation with commercialization pathways
contract InnovationCommercializationBridge {
    address public overseer;
    uint256 public bridgeCount;

    struct InnovationRecord {
        uint256 id;
        string institution;   // university or ORIC name
        string ipAsset;       // patent, copyright, trademark
        string linkage;       // industry partner or tech transfer office
        string commercialization; // commercialization outcome (licensed, startup, none)
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => InnovationRecord) public records;

    event InnovationLogged(uint256 indexed id, string institution, string ipAsset, string linkage, string commercialization, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs innovation commercialization record
    function logInnovation(string calldata institution, string calldata ipAsset, string calldata linkage, string calldata commercialization, string calldata notes) external onlyOverseer {
        bridgeCount++;
        records[bridgeCount] = InnovationRecord({
            id: bridgeCount,
            institution: institution,
            ipAsset: ipAsset,
            linkage: linkage,
            commercialization: commercialization,
            notes: notes,
            timestamp: block.timestamp
        });
        emit InnovationLogged(bridgeCount, institution, ipAsset, linkage, commercialization, notes);
    }

    /// @notice Citizens can view innovation commercialization records
    function viewInnovation(uint256 id) external view returns (InnovationRecord memory) {
        return records[id];
    }
}
