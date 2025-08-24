// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AggressiveNation_DataDisruptionProtocol {
    address public steward = msg.sender;

    struct Nation {
        string name;
        bool isAggressive;
        bool disruptionTriggered;
        uint256 timestamp;
    }

    mapping(string => Nation) public disruptionLog;

    event AggressionFlagged(string nation, string threatType, uint256 timestamp);
    event DataDisruptionExecuted(string nation, string disruptionScope, uint256 timestamp);

    function flagAggression(string memory nation, string memory threatType) public {
        disruptionLog[nation] = Nation(nation, true, true, block.timestamp);

        emit AggressionFlagged(nation, threatType, block.timestamp);
        emit DataDisruptionExecuted(nation, "System-based data pipelines, AI builds, robotic infrastructure", block.timestamp);
    }

    function isDisrupted(string memory nation) public view returns (bool) {
        return disruptionLog[nation].disruptionTriggered;
    }
}
