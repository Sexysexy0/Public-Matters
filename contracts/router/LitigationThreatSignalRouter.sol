// SPDX-License-Identifier: LitigationThreatSignal-License
pragma solidity ^0.8.0;

contract LitigationThreatSignalRouter {
    address public steward;

    struct ThreatSignal {
        string freelancerID;
        string threatType;
        string entityName;
        bool restorationActivated;
        string emotionalAPR;
        uint256 timestamp;
    }

    ThreatSignal[] public signals;

    event LitigationThreatRouted(string freelancerID, string threatType, string entityName, bool restorationActivated, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeThreat(string memory freelancerID, string memory threatType, string memory entityName, bool restorationActivated, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ThreatSignal(freelancerID, threatType, entityName, restorationActivated, emotionalAPR, block.timestamp));
        emit LitigationThreatRouted(freelancerID, threatType, entityName, restorationActivated, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, string memory, uint256) {
        ThreatSignal memory s = signals[index];
        return (s.freelancerID, s.threatType, s.entityName, s.restorationActivated, s.emotionalAPR, s.timestamp);
    }
}
