// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CrisisManagementCodex
/// @notice Codex covenant to encode structured response protocols and leadership accountability
contract CrisisManagementCodex {
    address public overseer;
    uint256 public crisisCount;

    struct CrisisRecord {
        uint256 id;
        string protocol;    // incident response, containment, communication
        string safeguard;   // accountability clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => CrisisRecord) public records;

    event CrisisLogged(uint256 indexed id, string protocol, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs crisis response protocol
    function logCrisis(string calldata protocol, string calldata safeguard, string calldata notes) external onlyOverseer {
        crisisCount++;
        records[crisisCount] = CrisisRecord({
            id: crisisCount,
            protocol: protocol,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CrisisLogged(crisisCount, protocol, safeguard);
    }

    /// @notice Citizens can view crisis response records
    function viewCrisis(uint256 id) external view returns (CrisisRecord memory) {
        return records[id];
    }
}
