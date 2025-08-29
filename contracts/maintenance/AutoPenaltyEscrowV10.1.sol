// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV10_1
 * @notice On-chain quadratic voting for households to choose relief type.
 */
contract AutoPenaltyEscrowV10_1 {
    address public steward;

    enum ReliefType { Cash, Goods, Mixed }

    struct Household {
        bool verified;
        uint256 credits; // vote credits assigned per proposal
    }

    struct VoteInfo {
        bool voted;
        uint256 cashVotes;
        uint256 goodsVotes;
        uint256 mixedVotes;
    }

    struct Proposal {
        uint256 totalAmount;
        uint256 totalCredits;
        mapping(address => VoteInfo) votes;
        uint256 cashScore;
        uint256 goodsScore;
        uint256 mixedScore;
        bool finalized;
        ReliefType finalType;
    }

    mapping(address => Household) public households;
    address[] public householdIndex;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    event HouseholdRegistered(address wallet, uint256 credits);
    event ProposalCreated(uint256 id, uint256 totalAmount, uint256 creditsPerHH);
    event Voted(address household, uint256 proposalId, uint256 cashVotes, uint256 goodsVotes, uint256 mixedVotes);
    event Finalized(uint256 proposalId, ReliefType finalType);

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyHousehold() {
        require(households[msg.sender].verified, "Not household");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerHousehold(address wallet) external onlySteward {
        households[wallet] = Household(true, 0);
        householdIndex.push(wallet);
        emit HouseholdRegistered(wallet, 0);
    }

    function createProposal(uint256 totalAmount, uint256 creditsPerHH) external onlySteward {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.totalAmount = totalAmount;
        for (uint256 i; i < householdIndex.length; i++) {
            households[householdIndex[i]].credits = creditsPerHH;
        }
        emit ProposalCreated(proposalCount, totalAmount, creditsPerHH);
    }

    function quadraticCost(uint256 votes) public pure returns (uint256) {
        return votes * votes; // cost = votes²
    }

    function vote(uint256 proposalId, uint256 cashVotes, uint256 goodsVotes, uint256 mixedVotes) external onlyHousehold {
        Proposal storage p = proposals[proposalId];
        require(!p.finalized, "Finalized");
        VoteInfo storage v = p.votes[msg.sender];
        require(!v.voted, "Already voted");

        uint256 totalCost = quadraticCost(cashVotes) + quadraticCost(goodsVotes) + quadraticCost(mixedVotes);
        require(totalCost <= households[msg.sender].credits, "Not enough credits");

        v.voted = true;
        v.cashVotes = cashVotes;
        v.goodsVotes = goodsVotes;
        v.mixedVotes = mixedVotes;

        // Quadratic score = votes (not cost)
        p.cashScore += cashVotes;
        p.goodsScore += goodsVotes;
        p.mixedScore += mixedVotes;

        emit Voted(msg.sender, proposalId, cashVotes, goodsVotes, mixedVotes);
    }

    function finalize(uint256 proposalId) external onlySteward {
        Proposal storage p = proposals[proposalId];
        require(!p.finalized, "Already finalized");

        if (p.cashScore >= p.goodsScore && p.cashScore >= p.mixedScore) {
            p.finalType = ReliefType.Cash;
        } else if (p.goodsScore >= p.cashScore && p.goodsScore >= p.mixedScore) {
            p.finalType = ReliefType.Goods;
        } else {
            p.finalType = ReliefType.Mixed;
        }

        p.finalized = true;
        emit Finalized(proposalId, p.finalType);
    }
}
