// contracts/CommunalVerdict.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CommunalVerdict
 * @notice Protocol for communal decision-making and verdicts on public issues.
 */
contract CommunalVerdict {
    address public admin;

    struct Verdict {
        string issue;
        string decision;   // "Support", "Oppose", "Neutral"
        uint256 votes;
        uint256 timestamp;
    }

    Verdict[] public verdicts;

    event VerdictLogged(string issue, string decision, uint256 votes, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logVerdict(string calldata issue, string calldata decision, uint256 votes) external onlyAdmin {
        verdicts.push(Verdict(issue, decision, votes, block.timestamp));
        emit VerdictLogged(issue, decision, votes, block.timestamp);
    }

    function totalVerdicts() external view returns (uint256) { return verdicts.length; }

    function getVerdict(uint256 id) external view returns (Verdict memory) {
        require(id < verdicts.length, "Invalid id");
        return verdicts[id];
    }
}
