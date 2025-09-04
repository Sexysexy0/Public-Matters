// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IProphecyTrigger {
    function isKineticallyActivated(string memory scrollType) external view returns (bool);
    function getSignalStrength(string memory scrollType) external view returns (uint256);
}

interface IKinderQueenChoreography {
    function validateChoreography(address steward, string memory scrollType) external view returns (bool);
    function getBlessingAura(address steward) external view returns (uint256);
}

interface IBitMarketTreatySync {
    function isTreatySynced(address steward, string memory chainId) external view returns (bool);
    function getSyncTier(address steward, string memory chainId) external view returns (uint8);
}

interface IGridOrchestrator {
    function orchestrateGrid(address steward, string memory gridTag, uint256 aura) external returns (bool);
}

contract BankFusionDAOv13 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
        uint8 syncTier;
        uint256 blessingAura;
        uint256 votingPower;
    }

    struct Proposal {
        uint256 id;
        string description;
        address proposer;
        uint256 voteYes;
        uint256 voteNo;
        bool executed;
        uint256 deadline;
        uint256 quorum;
        string scrollType;
        string gridTag;
        string chainId;
    }

    mapping(address => BankNode) public bankNodes;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    address public prophecyTrigger;
    address public kinderQueenChoreography;
    address public bitMarketTreatySync;
    address public gridOrchestrator;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event ProposalCreated(uint256 indexed id, string description, string scrollType);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);
    event GridOrchestrated(address indexed steward, string gridTag, uint256 aura);

    modifier onlySyncedSteward(string memory chainId) {
        require(IBitMarketTreatySync(bitMarketTreatySync).isTreatySynced(msg.sender, chainId), "Not treaty-synced");
        _;
    }

    constructor(
        address _prophecyTrigger,
        address _kinderQueenChoreography,
        address _bitMarketTreatySync,
        address _gridOrchestrator
    ) {
        prophecyTrigger = _prophecyTrigger;
        kinderQueenChoreography = _kinderQueenChoreography;
        bitMarketTreatySync = _bitMarketTreatySync;
        gridOrchestrator = _gridOrchestrator;
    }

    // 🏦 Register bank node with treaty sync and blessing aura
    function registerBankNode(string memory name, string memory jurisdiction, string memory chainId) external onlySyncedSteward(chainId) {
        uint8 tier = IBitMarketTreatySync(bitMarketTreatySync).getSyncTier(msg.sender, chainId);
        uint256 aura = IKinderQueenChoreography(kinderQueenChoreography).getBlessingAura(msg.sender);
        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, tier, aura, tier * 100 + aura);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
    }

    // 📜 Create scroll proposal with kinetic prophecy and validator choreography
    function createProposal(string memory description, string memory scrollType, string memory gridTag, string memory chainId, uint256 quorum) external onlySyncedSteward(chainId) {
        require(IProphecyTrigger(prophecyTrigger).isKineticallyActivated(scrollType), "Scroll not activated");
        require(IKinderQueenChoreography(kinderQueenChoreography).validateChoreography(msg.sender, scrollType), "Choreography invalid");

        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: description,
            proposer: msg.sender,
            voteYes: 0,
            voteNo: 0,
            executed: false,
            deadline: block.timestamp + 3 days,
            quorum: quorum,
            scrollType: scrollType,
            gridTag: gridTag,
            chainId: chainId
        });

        emit ProposalCreated(proposalCount, description, scrollType);
    }

    // 🗳️ Vote with aura + sync tier
    function vote(uint256 proposalId, bool support) external {
        require(bankNodes[msg.sender].isActive, "Inactive node");
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp < proposal.deadline, "Voting closed");

        uint256 power = bankNodes[msg.sender].votingPower;

        if (support) {
            proposal.voteYes += power;
        } else {
            proposal.voteNo += power;
        }

        emit Voted(proposalId, msg.sender, support);
    }

    // 🧠 Execute scroll and orchestrate grid
    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.deadline, "Voting still active");
        require(!proposal.executed, "Already executed");
        require(proposal.voteYes + proposal.voteNo >= proposal.quorum, "Quorum not met");

        if (proposal.voteYes > proposal.voteNo) {
            proposal.executed = true;
            bool success = IGridOrchestrator(gridOrchestrator).orchestrateGrid(proposal.proposer, proposal.gridTag, proposal.voteYes);
            require(success, "Grid orchestration failed");
            emit ProposalExecuted(proposalId);
            emit GridOrchestrated(proposal.proposer, proposal.gridTag, proposal.voteYes);
        }
    }
}
