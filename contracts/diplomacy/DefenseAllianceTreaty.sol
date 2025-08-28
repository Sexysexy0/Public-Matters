// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title DefenseAllianceTreaty
/// @notice Ritualizes mutual defense agreements between sovereign nations
contract DefenseAllianceTreaty {
    struct Ally {
        string name;
        bool active;
    }

    mapping(address => Ally) public allies;
    address public steward;

    event AllyJoined(address indexed allyAddress, string name, uint256 timestamp);
    event TreatyActivated(string clause, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function joinTreaty(address allyAddress, string memory name) public onlySteward {
        allies[allyAddress] = Ally(name, true);
        emit AllyJoined(allyAddress, name, block.timestamp);
    }

    function activateClause(string memory clause) public onlySteward {
        emit TreatyActivated(clause, block.timestamp);
    }

    function isAlly(address allyAddress) public view returns (bool) {
        return allies[allyAddress].active;
    }
}
