// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InfluenceBridge
/// @notice Bridge covenant to encode interpretive and forward-looking influence in board reporting
contract InfluenceBridge {
    address public overseer;
    uint256 public influenceCount;

    struct InfluenceRecord {
        uint256 id;
        string framing;     // implications, trade-offs, recommended actions
        string safeguard;   // accountability clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => InfluenceRecord) public records;

    event InfluenceLogged(uint256 indexed id, string framing, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs influence framing record
    function logInfluence(string calldata framing, string calldata safeguard, string calldata notes) external onlyOverseer {
        influenceCount++;
        records[influenceCount] = InfluenceRecord({
            id: influenceCount,
            framing: framing,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit InfluenceLogged(influenceCount, framing, safeguard);
    }

    /// @notice Citizens can view influence framing records
    function viewInfluence(uint256 id) external view returns (InfluenceRecord memory) {
        return records[id];
    }
}
