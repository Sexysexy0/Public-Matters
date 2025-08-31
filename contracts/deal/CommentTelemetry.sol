// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract CommentTelemetry {
    struct CivicPulse {
        string username;
        string sentiment;
        string sarcasmTag;
        string fatigueLevel;
    }

    CivicPulse[] public pulses;

    function logPulse(
        string memory _username,
        string memory _sentiment,
        string memory _sarcasmTag,
        string memory _fatigueLevel
    ) public {
        pulses.push(CivicPulse(_username, _sentiment, _sarcasmTag, _fatigueLevel));
    }

    function getPulse(uint index) public view returns (CivicPulse memory) {
        return pulses[index];
    }
}
