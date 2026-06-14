// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title VehicleInteractionLedger
/// @notice Ledger covenant to record and balance operator abilities affecting vehicles
contract VehicleInteractionLedger {
    address public overseer;
    uint256 public entryCount;

    struct VehicleRecord {
        uint256 id;
        string operator;   // e.g., N-TWO, Uluru, Gizmo
        string ability;    // freeze grenade, incendiary, EMP
        string effect;     // slowdown, immobilize, burn, disable
        string vehicle;    // tank, jeep, helicopter
        string notes;      // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => VehicleRecord) public records;

    event VehicleLogged(uint256 indexed id, string operator, string ability, string effect, string vehicle, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs vehicle interaction record
    function logVehicle(string calldata operator, string calldata ability, string calldata effect, string calldata vehicle, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = VehicleRecord({
            id: entryCount,
            operator: operator,
            ability: ability,
            effect: effect,
            vehicle: vehicle,
            notes: notes,
            timestamp: block.timestamp
        });
        emit VehicleLogged(entryCount, operator, ability, effect, vehicle, notes);
    }

    /// @notice Citizens can view vehicle interaction records
    function viewVehicle(uint256 id) external view returns (VehicleRecord memory) {
        return records[id];
    }
}
