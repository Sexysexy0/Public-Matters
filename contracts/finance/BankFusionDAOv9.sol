// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IMemorySync {
    function getScrollHistory(address steward) external view returns (uint256);
    function syncMemory(address steward, string memory scrollType) external returns (bool);
}

interface IValidatorAvatar {
    function validateScroll(address steward, string memory scrollType) external view returns (bool);
    function getAvatarTier(address steward) external view returns (uint8);
}

interface ICurriculumBroadcast {
    function broadcastLesson(string memory scrollType) external returns (bool);
    function isBroadcastLive(string memory scrollType) external view returns (bool);
}

interface IQuorumModulator {
    function modulateQuorum(uint256 baseQuorum, uint8 avatarTier, uint256 memoryScore) external view returns (uint256);
}

contract BankFusionDAOv9 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
        uint256 emotionalAPR;
        uint8 avatarTier;
        uint256 memoryScore;
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

    address public memorySync;
    address public validatorAvatar;
    address public curriculumBroadcast;
    address public quorumModulator;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event ProposalCreated(uint256 indexed id, string description, string scrollType);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);
    event MemorySynced(address indexed steward, string scrollType);
    event LessonBroadcasted(string scrollType);

    modifier onlyActiveNode() {
        require(bankNodes[msg.sender].isActive, "Inactive node");
        _;
    }

    constructor(
        address _memorySync,
        address _validatorAvatar,
        address _curriculumBroadcast,
        address _quorumModulator
    ) {
        memorySync = _memorySync;
        validatorAvatar = _validatorAvatar;
        curriculumBroadcast = _curriculumBroadcast;
        quorumModulator = _quorumModulator;
    }

    // 🏦 Register bank node with memory sync and avatar tier
    function registerBankNode(string memory name, string memory jurisdiction, string memory scrollType) external {
        require(IValidatorAvatar(validatorAvatar).validateScroll(msg.sender, scrollType), "Scroll rejected");

        uint8 tier = IValidatorAvatar(validatorAvatar).getAvatarTier(msg.sender);
        uint256 memoryScore = IMemorySync(memorySync).getScrollHistory(msg.sender);
        uint256 apr = tier * 100 + memoryScore;

        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, apr, tier, memoryScore, apr + tier * 10);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
    }

    // 📜 Create scroll proposal with broadcast and quorum modulation
    function createProposal(string memory description, string memory scrollType, uint256 baseQuorum) external onlyActiveNode {
        require(ICurriculumBroadcast(curriculumBroadcast).isBroadcastLive(scrollType), "Broadcast not live");

        uint8 tier = bankNodes[msg.sender].avatarTier;
        uint256 memoryScore = bankNodes[msg.sender].memoryScore;
        uint256 quorum = IQuorumModulator(quorumModulator).modulateQuorum(baseQuorum, tier, memoryScore);

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

    // 🧠 Sync memory for scroll type
    function syncScrollMemory(string memory scrollType) external onlyActiveNode {
        require(IMemorySync(memorySync).syncMemory(msg.sender, scrollType), "Sync failed");
        emit MemorySynced(msg.sender, scrollType);
    }

    // 📡 Broadcast curriculum lesson
    function broadcastLesson(string memory scrollType) external {
        require(ICurriculumBroadcast(curriculumBroadcast).broadcastLesson(scrollType), "Broadcast failed");
        emit LessonBroadcasted(scrollType);
    }

    // 🗳️ Vote with emotional APR + memory score
    function vote(uint256 proposalId, bool support) external onlyActiveNode {
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
