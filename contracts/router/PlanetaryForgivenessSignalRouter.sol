// SPDX-License-Identifier: PlanetaryForgivenessSignal-License
pragma solidity ^0.8.0;

contract PlanetaryForgivenessSignalRouter {
    address public steward;

    struct ForgivenessSignal {
        string actorID;
        string offenseType;
        string sanctumID;
        bool restorationActivated;
        string emotionalAPR;
        uint256 timestamp;
    }

    ForgivenessSignal[] public signals;

    event ForgivenessSignalRouted(string actorID, string offenseType, string sanctumID, bool restorationActivated, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeForgiveness(string memory actorID, string memory offenseType, string memory sanctumID, bool restorationActivated, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ForgivenessSignal(actorID, offenseType, sanctumID, restorationActivated, emotionalAPR, block.timestamp));
        emit ForgivenessSignalRouted(actorID, offenseType, sanctumID, restorationActivated, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, string memory, uint256) {
        ForgivenessSignal memory s = signals[index];
        return (s.actorID, s.offenseType, s.sanctumID, s.restorationActivated, s.emotionalAPR, s.timestamp);
    }
}
