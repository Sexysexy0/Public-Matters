// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PrivateSanctumReroute {
    struct Unit {
        string unitID;
        address originalOwner;
        string barangay;
        string emotionalTag; // e.g. "DamayClause", "SanctumGlow", "AuditGlow"
        bool isOccupied;
        uint256 timestamp;
    }

    mapping(string => Unit) public reroutedUnits;

    event UnitRerouted(string unitID, string barangay, string emotionalTag, uint256 timestamp);

    function rerouteUnit(
        string memory _unitID,
        address _originalOwner,
        string memory _barangay,
        string memory _emotionalTag
    ) public {
        reroutedUnits[_unitID] = Unit({
            unitID: _unitID,
            originalOwner: _originalOwner,
            barangay: _barangay,
            emotionalTag: _emotionalTag,
            isOccupied: false,
            timestamp: block.timestamp
        });

        emit UnitRerouted(_unitID, _barangay, _emotionalTag, block.timestamp);
    }

    function markOccupied(string memory _unitID) public {
        reroutedUnits[_unitID].isOccupied = true;
    }
}
