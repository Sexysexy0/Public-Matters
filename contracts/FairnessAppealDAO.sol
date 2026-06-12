// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FairnessAppealDAO
/// @notice DAO for taxpayer appeals on refund dispute resolutions
contract FairnessAppealDAO {
    address public oversightCommittee;
    uint256 public appealCount;

    struct Appeal {
        uint256 id;
        address appellant;
        string reason;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
        uint256 timestamp;
    }

    mapping(uint256 => Appeal) public appeals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event AppealFiled(uint256 indexed id, address indexed appellant, string reason);
    event AppealVoted(uint256 indexed id, address indexed voter, bool support);
    event AppealExecuted(uint256 indexed id, bool upheld);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Taxpayer files an appeal
    function fileAppeal(string calldata reason) external {
        appealCount++;
        appeals[appealCount] = Appeal({
            id: appealCount,
            appellant: msg.sender,
            reason: reason,
            yesVotes: 0,
            noVotes: 0,
            executed: false,
            timestamp: block.timestamp
        });
        emit AppealFiled(appealCount, msg.sender, reason);
    }

    /// @notice Citizens vote on appeal
    function voteAppeal(uint256 id, bool support) external {
        require(!hasVoted[msg.sender][id], "Already voted");
        Appeal storage a = appeals[id];
        require(!a.executed, "Already executed");

        hasVoted[msg.sender][id] = true;
        if (support) {
            a.yesVotes++;
        } else {
            a.noVotes++;
        }
        emit AppealVoted(id, msg.sender, support);
    }

    /// @notice Oversight executes appeal outcome
    function executeAppeal(uint256 id) external onlyOversight {
        Appeal storage a = appeals[id];
        require(!a.executed, "Already executed");
        a.executed = true;
        bool upheld = a.yesVotes > a.noVotes;
        emit AppealExecuted(id, upheld);
    }
}
