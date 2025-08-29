// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV11
 * @notice Adds time-bound emergency voting for relief type selection.
 */
contract AutoPenaltyEscrowV11 {
    address public steward;

    enum ReliefType { Cash, Goods, Mixed }

    struct Household {
        bool verified;
    }

    struct Proposal {
        uint256 totalAmount;
        uint256 startTime;
        uint256 votingPeriod; // in seconds
        uint256 cashVotes;
        uint256 goodsVotes;
        uint256 mixedVotes;
        bool finalized;
        ReliefType finalType;
        mapping(address => bool) hasVoted;
    }

    mapping(address => Household) public households;
    mapping(uint256 => Proposal) public proposals;
    address[] public householdIndex;
    uint256 public proposalCount;

    event HouseholdRegistered(address wallet);
    event ProposalCreated(uint256 proposalId, uint256 totalAmount, uint256 votingPeriod);
    event Voted(uint256 proposalId, address voter, ReliefType choice);
    event Finalized(uint256 proposalId, ReliefType finalType);

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyHousehold() { require(households[msg.sender].verified, "Not household"); _; }

    constructor() {
        steward = msg.sender;
    }

    function registerHousehold(address wallet) external onlySteward {
        require(!households[wallet].verified, "Already verified");
        households[wallet].verified = true;
        householdIndex.push(wallet);
        emit HouseholdRegistered(wallet);
    }

    function createProposal(uint256 totalAmount, uint256 votingPeriod) external onlySteward {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.totalAmount = totalAmount;
        p.startTime = block.timestamp;
        p.votingPeriod = votingPeriod;
        emit ProposalCreated(proposalCount, totalAmount, votingPeriod);
    }

    function vote(uint256 proposalId, ReliefType choice) external onlyHousehold {
        Proposal storage p = proposals[proposalId];
        require(block.timestamp <= p.startTime + p.votingPeriod, "Voting closed");
        require(!p.hasVoted[msg.sender], "Already voted");
        require(!p.finalized, "Finalized");

        p.hasVoted[msg.sender] = true;
        if (choice == ReliefType.Cash) p.cashVotes++;
        else if (choice == ReliefType.Goods) p.goodsVotes++;
        else p.mixedVotes++;

        emit Voted(proposalId, msg.sender, choice);
    }

    function finalize(uint256 proposalId) public {
        Proposal storage p = proposals[proposalId];
        require(!p.finalized, "Already finalized");
        require(block.timestamp > p.startTime + p.votingPeriod, "Voting still active");

        if (p.cashVotes >= p.goodsVotes && p.cashVotes >= p.mixedVotes) {
            p.finalType = ReliefType.Cash;
        } else if (p.goodsVotes >= p.cashVotes && p.goodsVotes >= p.mixedVotes) {
            p.finalType = ReliefType.Goods;
        } else {
            p.finalType = ReliefType.Mixed;
        }
        p.finalized = true;

        emit Finalized(proposalId, p.finalType);
    }
}
