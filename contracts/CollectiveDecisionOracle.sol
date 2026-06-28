// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CollectiveDecisionOracle
/// @notice Covenant contract for citizen collective decision-making
contract CollectiveDecisionOracle {
    address public overseer;
    uint256 public decisionCount;

    struct DecisionSession {
        uint256 id;
        string topic;
        uint256 yesVotes;
        uint256 noVotes;
        bool closed;
        uint256 timestamp;
    }

    mapping(uint256 => DecisionSession) public decisions;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event DecisionOpened(uint256 indexed id, string topic);
    event VoteCast(uint256 indexed id, address voter, bool vote);
    event DecisionClosed(uint256 indexed id, string topic, uint256 yesVotes, uint256 noVotes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function openDecision(string calldata topic) external onlyOverseer {
        decisionCount++;
        decisions[decisionCount] = DecisionSession({
            id: decisionCount,
            topic: topic,
            yesVotes: 0,
            noVotes: 0,
            closed: false,
            timestamp: block.timestamp
        });
        emit DecisionOpened(decisionCount, topic);
    }

    function castVote(uint256 id, bool vote) external {
        DecisionSession storage session = decisions[id];
        require(!session.closed, "Decision closed");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;
        if (vote) {
            session.yesVotes++;
        } else {
            session.noVotes++;
        }
        emit VoteCast(id, msg.sender, vote);
    }

    function closeDecision(uint256 id) external onlyOverseer {
        DecisionSession storage session = decisions[id];
        require(!session.closed, "Already closed");
        session.closed = true;
        emit DecisionClosed(id, session.topic, session.yesVotes, session.noVotes);
    }

    function viewDecision(uint256 id) external view returns (DecisionSession memory) {
        return decisions[id];
    }
}
