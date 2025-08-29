// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV10
 * @notice Adds on-chain household voting to finalize relief type before payout.
 */
contract AutoPenaltyEscrowV10 {
    address public steward;

    enum ReliefType { Cash, Goods, Mixed }

    struct Household {
        bool verified;
        address wallet;
    }

    struct VoteInfo {
        bool hasVoted;
        ReliefType choice;
    }

    struct ReliefProposal {
        uint256 totalAmount;
        address[] voters; 
        mapping(address => VoteInfo) votes;
        uint256 cashVotes;
        uint256 goodsVotes;
        uint256 mixedVotes;
        bool finalized;
        ReliefType finalType;
    }

    mapping(address => Household) public households;
    address[] public householdIndex;
    uint256 public proposalCount;
    mapping(uint256 => ReliefProposal) public proposals;

    event HouseholdRegistered(address wallet);
    event ProposalCreated(uint256 proposalId, uint256 totalAmount);
    event Voted(uint256 proposalId, address household, ReliefType choice);
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
        require(!households[wallet].verified, "Already verified");
        households[wallet] = Household(true, wallet);
        householdIndex.push(wallet);
        emit HouseholdRegistered(wallet);
    }

    function createProposal(uint256 totalAmount) external onlySteward {
        proposalCount++;
        ReliefProposal storage p = proposals[proposalCount];
        p.totalAmount = totalAmount;
        emit ProposalCreated(proposalCount, totalAmount);
    }

    function vote(uint256 proposalId, ReliefType choice) external onlyHousehold {
        ReliefProposal storage p = proposals[proposalId];
        require(!p.votes[msg.sender].hasVoted, "Already voted");
        require(!p.finalized, "Already finalized");

        p.votes[msg.sender] = VoteInfo(true, choice);
        p.voters.push(msg.sender);

        if (choice == ReliefType.Cash) p.cashVotes++;
        else if (choice == ReliefType.Goods) p.goodsVotes++;
        else p.mixedVotes++;

        emit Voted(proposalId, msg.sender, choice);
    }

    function finalize(uint256 proposalId) external onlySteward {
        ReliefProposal storage p = proposals[proposalId];
        require(!p.finalized, "Already finalized");

        // Tally winner
        if (p.cashVotes >= p.goodsVotes && p.cashVotes >= p.mixedVotes) {
            p.finalType = ReliefType.Cash;
        } else if (p.goodsVotes >= p.cashVotes && p.goodsVotes >= p.mixedVotes) {
            p.finalType = ReliefType.Goods;
        } else {
            p.finalType = ReliefType.Mixed;
        }
        p.finalized = true;
        emit Finalized(proposalId, p.finalType);

        // Distribution logic for chosen type would be handled here in integration
    }
}
