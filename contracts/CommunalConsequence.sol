// contracts/CommunalConsequence.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunalConsequence {
    struct Consequence {
        string project;
        string outcome;
        uint256 timestamp;
        address reporter;
    }

    Consequence[] public consequences;
    event ConsequenceLogged(string project, string outcome, address reporter, uint256 timestamp);

    function logConsequence(string calldata project, string calldata outcome) external {
        consequences.push(Consequence(project, outcome, block.timestamp, msg.sender));
        emit ConsequenceLogged(project, outcome, msg.sender, block.timestamp);
    }

    function totalConsequences() external view returns (uint256) {
        return consequences.length;
    }
}
