// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SoloModePersistenceShield
/// @notice Shield covenant to enforce permanent Solo Mode availability
contract SoloModePersistenceShield {
    address public overseer;
    bool public isPermanent;
    uint256 public shieldCount;

    struct PersistenceRecord {
        uint256 id;
        string mode;        // Solo, Duo, Squad
        bool permanent;     // true if enforced permanent
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => PersistenceRecord) public records;

    event PersistenceLogged(uint256 indexed id, string mode, bool permanent, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
        isPermanent = true; // default enforce Solo mode permanence
    }

    /// @notice Overseer logs persistence record
    function logPersistence(string calldata mode, bool permanent, string calldata notes) external onlyOverseer {
        shieldCount++;
        records[shieldCount] = PersistenceRecord({
            id: shieldCount,
            mode: mode,
            permanent: permanent,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PersistenceLogged(shieldCount, mode, permanent, notes);
    }

    /// @notice Citizens can view persistence records
    function viewPersistence(uint256 id) external view returns (PersistenceRecord memory) {
        return records[id];
    }

    /// @notice Overseer can update permanence enforcement
    function updatePermanence(bool permanent) external onlyOverseer {
        isPermanent = permanent;
    }
}
