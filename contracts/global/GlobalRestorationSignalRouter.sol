// SPDX-License-Identifier: GlobalRestorationSignal-License
pragma solidity ^0.8.0;

contract GlobalRestorationSignalRouter {
    address public steward;

    struct RestorationSignal {
        string sanctumID;
        string hostNation;
        string threatVector;
        string restorationScore;
        string emotionalAPR;
        uint256 timestamp;
    }

    RestorationSignal[] public signals;

    event RestorationSignalRouted(string sanctumID, string hostNation, string threatVector, string restorationScore, string emotionalAPR, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory sanctumID, string memory hostNation, string memory threatVector, string memory restorationScore, string memory emotionalAPR) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(RestorationSignal(sanctumID, hostNation, threatVector, restorationScore, emotionalAPR, block.timestamp));
        emit RestorationSignalRouted(sanctumID, hostNation, threatVector, restorationScore, emotionalAPR, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, string memory, uint256) {
        RestorationSignal memory s = signals[index];
        return (s.sanctumID, s.hostNation, s.threatVector, s.restorationScore, s.emotionalAPR, s.timestamp);
    }
}
