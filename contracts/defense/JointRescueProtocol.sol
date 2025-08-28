// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title JointRescueProtocol
/// @notice Ritualizes coordinated rescue operations across allied naval and coast guard units
contract JointRescueProtocol {
    address public steward;
    bool public protocolActivated;

    struct RescueEvent {
        string nation;
        string vessel;
        string location;
        string nature;
        string emotionalTag;
        uint256 timestamp;
    }

    RescueEvent[] public rescueLogs;

    event ProtocolActivated(uint256 timestamp);
    event RescueLogged(string nation, string vessel, string location, string nature, string emotionalTag, uint256 timestamp);

    constructor() {
        steward = msg.sender;
        protocolActivated = false;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function activateProtocol() public onlySteward {
        protocolActivated = true;
        emit ProtocolActivated(block.timestamp);
    }

    function logRescue(
        string memory nation,
        string memory vessel,
        string memory location,
        string memory nature,
        string memory emotionalTag
    ) public onlySteward {
        require(protocolActivated, "Protocol not yet activated");
        rescueLogs.push(RescueEvent(nation, vessel, location, nature, emotionalTag, block.timestamp));
        emit RescueLogged(nation, vessel, location, nature, emotionalTag, block.timestamp);
    }

    function getRescue(uint256 index) public view returns (RescueEvent memory) {
        return rescueLogs[index];
    }

    function totalRescues() public view returns (uint256) {
        return rescueLogs.length;
    }
}
