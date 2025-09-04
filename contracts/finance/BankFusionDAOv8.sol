// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITreatyOrchestrator {
    function getTreatyTier(address steward) external view returns (uint8);
    function isOrchestrated(address steward) external view returns (bool);
}

interface IAPRComposer {
    function composeAPR(address steward, string memory scrollType) external view returns (uint256);
}

interface ICurriculumMint {
    function mintLesson(address steward, string memory scrollType) external returns (bool);
    function isMinted(address steward, string memory scrollType) external view returns (bool);
}

interface IQuorumHarmonics {
    function getHarmonicQuorum(uint8 treatyTier, string memory scrollType) external view returns (uint256);
}

contract BankFusionDAOv8 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
        uint8 treatyTier;
        uint256 emotionalAPR;
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
    }

    mapping(address => BankNode) public bankNodes;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    address public treatyOrchestrator;
    address public aprComposer;
    address public curriculumMint;
    address public quorumHarmonics;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction, uint8 treatyTier);
    event ProposalCreated(uint256 indexed id, string description, string scrollType);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);
    event LessonMinted(address indexed steward, string scrollType);

    modifier onlyOrchestrated() {
        require(ITreatyOrchestrator(treatyOrchestrator).isOrchestrated(msg.sender), "Not treaty-orchestrated");
        _;
    }

    constructor(
        address _treatyOrchestrator,
        address _aprComposer,
        address _curriculumMint,
        address _quorumHarmonics
    ) {
        treatyOrchestrator = _treatyOrchestrator;
        aprComposer = _aprComposer;
        curriculumMint = _curriculumMint;
        quorumHarmonics = _quorumHarmonics;
    }

    // 🏦 Register bank node with treaty tier and composable APR
    function registerBankNode(string memory name, string memory jurisdiction, string memory scrollType) external onlyOrchestrated {
        uint8 tier = ITreatyOrchestrator(treatyOrchestrator).getTreatyTier(msg.sender);
        uint256 apr = IAPRComposer(aprComposer).composeAPR(msg.sender, scrollType);
        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, tier, apr, apr + tier * 10);
        emit BankNodeRegistered(msg.sender, name, jurisdiction, tier);
    }

    // 📜 Create scroll proposal with curriculum minting and harmonic quorum
    function createProposal(string memory description, string memory scrollType) external {
        require(bankNodes[msg.sender].isActive, "Inactive node");
        require(ICurriculumMint(curriculumMint).isMinted(msg.sender, scrollType), "Lesson not minted");

        uint8 tier = bankNodes[msg.sender].treatyTier;
        uint256 quorum = IQuorumHarmonics(quorumHarmonics).getHarmonicQuorum(tier, scrollType);

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
            scrollType: scrollType
        });

        emit ProposalCreated(proposalCount, description, scrollType);
    }

    // 🧬 Mint curriculum lesson
    function mintLesson(string memory scrollType) external {
        require(ICurriculumMint(curriculumMint).mintLesson(msg.sender, scrollType), "Mint failed");
        emit LessonMinted(msg.sender, scrollType);
    }

    // 🗳️ Vote with composable APR + treaty tier
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

    // 🧠 Execute scroll if quorum met
    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.deadline, "Voting still active");
        require(!proposal.executed, "Already executed");
        require(proposal.voteYes + proposal.voteNo >= proposal.quorum, "Quorum not met");

        if (proposal.voteYes > proposal.voteNo) {
            proposal.executed = true;
            emit ProposalExecuted(proposalId);
        }
    }
}
