// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NarrativeOracle {
    event NarrativeRecord(string project, string direction);

    function logNarrative(string memory _project, string memory _direction) external {
        emit NarrativeRecord(_project, _direction);
        // ORACLE: Narrative direction logged for governance.
    }
}
