// SPDX-License-Identifier: ReconciliationSanctum
pragma solidity ^0.8.19;

contract TechLeadershipRehireBeacon {
    struct RehireEvent {
        string ceoName;
        string company;
        string reasonForExit;
        string reconciliationMessage;
        bool rehired;
        bool forgivenessBroadcasted;
    }

    mapping(bytes32 => RehireEvent) public events;

    event CEORehired(string ceoName, string company);
    event ForgivenessBroadcasted(string ceoName, string message);

    function registerRehire(string memory ceoName, string memory company, string memory reasonForExit, string memory reconciliationMessage) public {
        bytes32 eventId = keccak256(abi.encodePacked(ceoName, company, block.timestamp));
        events[eventId] = RehireEvent(ceoName, company, reasonForExit, reconciliationMessage, false, false);
    }

    function confirmRehire(string memory ceoName, string memory company) public {
        bytes32 eventId = keccak256(abi.encodePacked(ceoName, company, block.timestamp));
        events[eventId].rehired = true;
        emit CEORehired(ceoName, company);
    }

    function broadcastForgiveness(string memory ceoName, string memory message) public {
        bytes32 eventId = keccak256(abi.encodePacked(ceoName, block.timestamp));
        events[eventId].forgivenessBroadcasted = true;
        events[eventId].reconciliationMessage = message;
        emit ForgivenessBroadcasted(ceoName, message);
    }

    function getRehireStatus(string memory ceoName, string memory company) public view returns (RehireEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(ceoName, company, block.timestamp));
        return events[eventId];
    }
}
