// SPDX-License-Identifier: TreatySanctum
pragma solidity ^0.8.19;

contract SovereignDefaultDeterrenceRouter {
    struct DefaultSignal {
        string country;
        uint256 debtToGDP;
        uint256 goldReservesTons;
        bool IMFProgram;
        bool flagged;
        string deterrenceMessage;
    }

    mapping(bytes32 => DefaultSignal) public signals;

    event DefaultRiskTagged(string country, uint256 debtToGDP);
    event DeterrenceBroadcasted(string country, string deterrenceMessage);

    function tagDefaultRisk(string memory country, uint256 debtToGDP, uint256 goldReservesTons, bool IMFProgram, string memory deterrenceMessage) public {
        bytes32 signalId = keccak256(abi.encodePacked(country, block.timestamp));
        signals[signalId] = DefaultSignal(country, debtToGDP, goldReservesTons, IMFProgram, true, deterrenceMessage);
        emit DefaultRiskTagged(country, debtToGDP);
    }

    function broadcastDeterrence(string memory country, string memory deterrenceMessage) public {
        bytes32 signalId = keccak256(abi.encodePacked(country, block.timestamp));
        signals[signalId].deterrenceMessage = deterrenceMessage;
        emit DeterrenceBroadcasted(country, deterrenceMessage);
    }

    function getSignalStatus(string memory country) public view returns (DefaultSignal memory) {
        bytes32 signalId = keccak256(abi.encodePacked(country, block.timestamp));
        return signals[signalId];
    }
}
