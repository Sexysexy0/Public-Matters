// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV12
 * @notice Multi-phase emergency voting: Phase 1 (relief type), Phase 2 (supplier selection)
 */
contract AutoPenaltyEscrowV12 {
    address public steward;

    enum ReliefType { Cash, Goods, Mixed }

    struct Household { bool verified; }

    struct Supplier {
        string name;
        address wallet;
        bool approved;
    }

    struct Proposal {
        uint256 totalAmount;
        uint256 startTimePhase1;
        uint256 votingPeriodPhase1;
        uint256 startTimePhase2;
        uint256 votingPeriodPhase2;

        // Phase 1 tallies
        uint256 cashVotes;
        uint256 goodsVotes;
        uint256 mixedVotes;
        bool phase1Finalized;
        ReliefType finalType;

        // Phase 2 tallies
        address[] supplierList;
        mapping(address => uint256) supplierVotes;
        bool phase2Finalized;
        address finalSupplier;

        mapping(address => bool) votedPhase1;
        mapping(address => bool) votedPhase2;
    }

    mapping(address => Household) public households;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => Supplier) public suppliers;

    uint256 public proposalCount;

    event HouseholdRegistered(address wallet);
    event SupplierRegistered(address wallet, string name);
    event ProposalCreated(uint256 proposalId, uint256 totalAmount, uint256 votingPeriodPhase1, uint256 votingPeriodPhase2);
    event VotedPhase1(uint256 proposalId, address voter, ReliefType choice);
    event VotedPhase2(uint256 proposalId, address voter, address supplier);
    event Phase1Finalized(uint256 proposalId, ReliefType finalType);
    event Phase2Finalized(uint256 proposalId, address finalSupplier);

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyHousehold() { require(households[msg.sender].verified, "Not household"); _; }

    constructor() { steward = msg.sender; }

    function registerHousehold(address wallet) external onlySteward {
        households[wallet] = Household(true);
        emit HouseholdRegistered(wallet);
    }

    function registerSupplier(address wallet, string calldata name) external onlySteward {
        suppliers[wallet] = Supplier(name, wallet, true);
        emit SupplierRegistered(wallet, name);
    }

    function createProposal(uint256 totalAmount, uint256 votingPeriodPhase1, uint256 votingPeriodPhase2, address[] calldata supplierCandidates) external onlySteward {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.totalAmount = totalAmount;
        p.startTimePhase1 = block.timestamp;
        p.votingPeriodPhase1 = votingPeriodPhase1;
        p.votingPeriodPhase2 = votingPeriodPhase2;
        p.supplierList = supplierCandidates;
        emit ProposalCreated(proposalCount, totalAmount, votingPeriodPhase1, votingPeriodPhase2);
    }

    // Phase 1 voting
    function votePhase1(uint256 proposalId, ReliefType choice) external onlyHousehold {
        Proposal storage p = proposals[proposalId];
        require(block.timestamp <= p.startTimePhase1 + p.votingPeriodPhase1, "Phase 1 closed");
        require(!p.votedPhase1[msg.sender], "Already voted P1");

        p.votedPhase1[msg.sender] = true;
        if (choice == ReliefType.Cash) p.cashVotes++;
        else if (choice == ReliefType.Goods) p.goodsVotes++;
        else p.mixedVotes++;

        emit VotedPhase1(proposalId, msg.sender, choice);
    }

    function finalizePhase1(uint256 proposalId) public {
        Proposal storage p = proposals[proposalId];
        require(!p.phase1Finalized, "P1 finalized");
        require(block.timestamp > p.startTimePhase1 + p.votingPeriodPhase1, "Phase 1 active");

        if (p.cashVotes >= p.goodsVotes && p.cashVotes >= p.mixedVotes) {
            p.finalType = ReliefType.Cash;
        } else if (p.goodsVotes >= p.cashVotes && p.goodsVotes >= p.mixedVotes) {
            p.finalType = ReliefType.Goods;
        } else {
            p.finalType = ReliefType.Mixed;
        }
        p.phase1Finalized = true;
        p.startTimePhase2 = block.timestamp;

        emit Phase1Finalized(proposalId, p.finalType);
    }

    // Phase 2 voting (supplier selection)
    function votePhase2(uint256 proposalId, address supplier) external onlyHousehold {
        Proposal storage p = proposals[proposalId];
        require(p.phase1Finalized, "P1 not finalized");
        require(block.timestamp <= p.startTimePhase2 + p.votingPeriodPhase2, "Phase 2 closed");
        require(!p.votedPhase2[msg.sender], "Already voted P2");

        // Supplier must be in candidate list and approved
        bool valid = false;
        for (uint256 i; i < p.supplierList.length; i++) {
            if (p.supplierList[i] == supplier && suppliers[supplier].approved) {
                valid = true;
                break;
            }
        }
        require(valid, "Invalid supplier");

        p.votedPhase2[msg.sender] = true;
        p.supplierVotes[supplier]++;

        emit VotedPhase2(proposalId, msg.sender, supplier);
    }

    function finalizePhase2(uint256 proposalId) public {
        Proposal storage p = proposals[proposalId];
        require(p.phase1Finalized, "P1 not finalized");
        require(!p.phase2Finalized, "P2 finalized");
        require(block.timestamp > p.startTimePhase2 + p.votingPeriodPhase2, "Phase 2 active");

        // Find supplier with most votes
        address winner;
        uint256 topVotes;
        for (uint256 i; i < p.supplierList.length; i++) {
            address s = p.supplierList[i];
            if (p.supplierVotes[s] > topVotes) {
                topVotes = p.supplierVotes[s];
                winner = s;
            }
        }
        p.finalSupplier = winner;
        p.phase2Finalized = true;

        emit Phase2Finalized(proposalId, winner);
    }
}
