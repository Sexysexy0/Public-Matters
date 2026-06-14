// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SupportRoleExpansionCodex
/// @notice Codex covenant to expand support role with heal stations and deflector mechanics
contract SupportRoleExpansionCodex {
    address public overseer;
    uint256 public codexCount;

    struct SupportRecord {
        uint256 id;
        string ability;     // heal station, grenade deflector, motion sensor
        string effect;      // heal, unfreeze, deflect, detect
        string beneficiary; // squad, vehicles, operators
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => SupportRecord) public records;

    event SupportLogged(uint256 indexed id, string ability, string effect, string beneficiary, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs support role expansion record
    function logSupport(string calldata ability, string calldata effect, string calldata beneficiary, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = SupportRecord({
            id: codexCount,
            ability: ability,
            effect: effect,
            beneficiary: beneficiary,
            notes: notes,
            timestamp: block.timestamp
        });
        emit SupportLogged(codexCount, ability, effect, beneficiary, notes);
    }

    /// @notice Citizens can view support role expansion records
    function viewSupport(uint256 id) external view returns (SupportRecord memory) {
        return records[id];
    }
}
