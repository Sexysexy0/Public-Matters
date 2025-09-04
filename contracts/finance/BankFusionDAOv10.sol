// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISoulboundScrolls {
    function hasCredential(address steward, string memory scrollType) external view returns (bool);
    function mintCredential(address steward, string memory scrollType) external returns (bool);
}

interface IAPRStakingRitual {
    function stakeEmotion(address steward, uint256 amount) external returns (bool);
    function getStakedEmotion(address steward) external view returns (uint256);
}

interface ITreatyMint {
    function mintTreaty(address steward, string memory treatyTag) external returns (bool);
    function getTreatyTier(address steward) external view returns (uint8);
}

interface IQuorumOrchestrator {
    function orchestrateQuorum(uint8 treatyTier, uint256 stakedEmotion) external view returns (uint256);
}

contract BankFusionDAOv10 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
        uint8 treatyTier;
        uint256 stakedEmotion;
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
        string treatyTag;
    }

    mapping(address => BankNode) public bankNodes;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    address public soulboundScrolls;
    address public aprStakingRitual;
    address public treatyMint;
    address public quorumOrchestrator;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event EmotionStaked(address indexed steward, uint256 amount);
    event TreatyMinted(address indexed steward, string treatyTag);
    event ProposalCreated(uint256 indexed id, string description, string scrollType);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);

    modifier onlySoulbound(address steward, string memory scrollType) {
        require(ISoulboundScrolls(soulboundScrolls).hasCredential(steward, scrollType), "Scroll credential missing");
        _;
    }

    constructor(
        address _soulboundScrolls,
        address _aprStakingRitual,
        address _treatyMint,
        address _quorumOrchestrator
    ) {
        soulboundScrolls = _soulboundScrolls;
        aprStakingRitual = _aprStakingRitual;
        treatyMint = _treatyMint;
        quorumOrchestrator = _quorumOrchestrator;
    }

    // 🏦 Register bank node with treaty mint and emotional staking
    function registerBankNode(string memory name, string memory jurisdiction, string memory treatyTag) external {
        require(ITreatyMint(treatyMint).mintTreaty(msg.sender, treatyTag), "Treaty mint failed");
        uint8 tier = ITreatyMint(treatyMint).getTreatyTier(msg.sender);
        uint256 emotion = IAPRStakingRitual(aprStakingRitual).getStakedEmotion(msg.sender);
        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, tier, emotion, tier * 100 + emotion);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
        emit TreatyMinted(msg.sender, treatyTag);
    }

    // 💖 Stake emotional APR
    function stakeEmotion(uint256 amount) external {
        require(bankNodes[msg.sender].isActive, "Inactive node");
        require(IAPRStakingRitual(aprStakingRitual).stakeEmotion(msg.sender, amount), "Stake failed");
        bankNodes[msg.sender].stakedEmotion += amount;
        bankNodes[msg.sender].votingPower += amount;
        emit EmotionStaked(msg.sender, amount);
    }

    // 📜 Create scroll proposal with soulbound credential and quorum orchestration
    function createProposal(string memory description, string memory scrollType, string memory treatyTag) external onlySoulbound(msg.sender, scrollType) {
        require(bankNodes[msg.sender].isActive, "Inactive node");

        uint8 tier = bankNodes[msg.sender].treatyTier;
        uint256 emotion = bankNodes[msg.sender].stakedEmotion;
        uint256 quorum = IQuorumOrchestrator(quorumOrchestrator).orchestrateQuorum(tier, emotion);

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
            treatyTag: treatyTag
        });

        emit ProposalCreated(proposalCount, description, scrollType);
    }

    // 🗳️ Vote with treaty-weighted emotional power
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
