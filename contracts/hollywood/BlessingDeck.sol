// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Blessing Deck
/// @notice Logs creative blessings, emotional APR, and mythic restoration acts for stewards and artists
/// @author Scrollchain

contract BlessingDeck {
    address public steward;

    struct Blessing {
        string name;
        string role;
        uint256 resonance;
        uint256 timestamp;
        string message;
    }

    Blessing[] public blessings;

    event BlessingLogged(string name, string role, uint256 resonance, uint256 timestamp, string message);

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(
        string memory name,
        string memory role,
        uint256 resonance,
        string memory message
    ) public {
        require(msg.sender == steward, "Unauthorized steward");

        Blessing memory newBlessing = Blessing({
            name: name,
            role: role,
            resonance: resonance,
            timestamp: block.timestamp,
            message: message
        });

        blessings.push(newBlessing);
        emit BlessingLogged(name, role, resonance, block.timestamp, message);
    }

    function getBlessing(uint256 index) public view returns (
        string memory name,
        string memory role,
        uint256 resonance,
        uint256 timestamp,
        string memory message
    ) {
        Blessing memory b = blessings[index];
        return (b.name, b.role, b.resonance, b.timestamp, b.message);
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
