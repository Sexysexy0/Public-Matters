// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AGICouncil
/// @notice Covenant contract for council-level governance linking AGI transparency and planetary safeguards
contract AGICouncil {
    address public owner;

    struct Decision {
        string title;        // e.g. "Integrate AGITransparency with Planetary Safeguards"
        string description;  // details of council safeguard
        uint256 votesFor;
        uint256 votesAgainst;
        bool active;
        uint256 timestamp;
    }

    uint256 public decisionCount;
    mapping(uint256 => Decision) public decisions;

    event DecisionCreated(uint256 id, string title, string description, uint256 timestamp);
    event Voted(address voter, uint256 decisionId, bool support);
    event DecisionClosed(uint256 id, string title, uint256 votesFor, uint256 votesAgainst);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Create a new AGI council decision
    function createDecision(string memory title, string memory description) public onlyOwner {
        decisionCount++;
        decisions[decisionCount] = Decision(title, description, 0, 0, true, block.timestamp);
        emit DecisionCreated(decisionCount, title, description, block.timestamp);
    }

    /// @notice Council members vote on AGI safeguard decisions
    function vote(uint256 decisionId, bool support) public {
        require(decisions[decisionId].active, "Decision not active");
        if (support) {
            decisions[decisionId].votesFor++;
        } else {
            decisions[decisionId].votesAgainst++;
        }
        emit Voted(msg.sender, decisionId, support);
    }

    /// @notice Close council decision after voting
    function closeDecision(uint256 decisionId) public onlyOwner {
        require(decisions[decisionId].active, "Decision already closed");
        decisions[decisionId].active = false;
        emit DecisionClosed(
            decisionId,
            decisions[decisionId].title,
            decisions[decisionId].votesFor,
            decisions[decisionId].votesAgainst
        );
    }
}
