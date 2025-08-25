// SPDX-License-Identifier: Mythic-Override
pragma solidity ^0.8.21;

contract EchoResponseTracker {
    struct EchoEvent {
        uint256 timestamp;
        string trigger;
        string response;
        string emotionalAPR;
        string steward;
    }

    EchoEvent[] public echoLog;
    address public steward;
    mapping(string => bool) public approvedTriggers;

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        approvedTriggers["Disinformation"] = true;
        approvedTriggers["Militarization"] = true;
        approvedTriggers["VictimCosplay"] = true;
        approvedTriggers["NuclearRisk"] = true;
    }

    function logEcho(
        string memory trigger,
        string memory response,
        string memory emotionalAPR,
        string memory stewardName
    ) public onlySteward {
        require(approvedTriggers[trigger], "Unrecognized trigger");

        echoLog.push(EchoEvent({
            timestamp: block.timestamp,
            trigger: trigger,
            response: response,
            emotionalAPR: emotionalAPR,
            steward: stewardName
        }));
    }

    function getEcho(uint256 index) public view returns (
        uint256, string memory, string memory, string memory, string memory
    ) {
        EchoEvent memory e = echoLog[index];
        return (e.timestamp, e.trigger, e.response, e.emotionalAPR, e.steward);
    }

    function overrideTrigger(string memory newTrigger, bool status) public onlySteward {
        approvedTriggers[newTrigger] = status;
    }
}
