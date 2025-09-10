// SPDX-License-Identifier: SanctumSurvivalKit-License
pragma solidity ^0.8.0;

contract SanctumSurvivalKitRouter {
    address public steward;

    struct KitSignal {
        string sanctumID;
        string hostNation;
        string kitType;
        string disruptionLevel;
        bool distributed;
        uint256 timestamp;
    }

    KitSignal[] public signals;

    event SurvivalKitRouted(string sanctumID, string hostNation, string kitType, string disruptionLevel, bool distributed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeKit(string memory sanctumID, string memory hostNation, string memory kitType, string memory disruptionLevel, bool distributed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(KitSignal(sanctumID, hostNation, kitType, disruptionLevel, distributed, block.timestamp));
        emit SurvivalKitRouted(sanctumID, hostNation, kitType, disruptionLevel, distributed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        KitSignal memory s = signals[index];
        return (s.sanctumID, s.hostNation, s.kitType, s.disruptionLevel, s.distributed, s.timestamp);
    }
}
