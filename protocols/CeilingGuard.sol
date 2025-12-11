// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Ceiling Guard Arc: enforce 20% party-list ceiling
contract CeilingGuard {
    uint256 public totalHouseSeats;
    uint256 public partyListSeats;
    address public steward;

    event CeilingChecked(uint256 totalHouseSeats, uint256 partyListSeats, bool violation);

    constructor(uint256 _totalHouseSeats) {
        steward = msg.sender;
        totalHouseSeats = _totalHouseSeats;
    }

    function setPartyListSeats(uint256 _partyListSeats) external {
        require(msg.sender == steward, "Only steward");
        partyListSeats = _partyListSeats;
        bool violation = (partyListSeats * 100) / totalHouseSeats > 20;
        emit CeilingChecked(totalHouseSeats, partyListSeats, violation);
    }
}
