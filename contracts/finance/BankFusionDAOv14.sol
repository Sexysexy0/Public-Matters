// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuraStaking {
    function stakeAura(address steward, uint256 amount) external returns (bool);
    function getAuraBalance(address steward) external view returns (uint256);
}

interface ITreatyReallocator {
    function reallocateTreaty(address steward, string memory treatyTag, uint256 aura) external returns (bool);
    function getTreatyWeight(address steward, string memory treatyTag) external view returns (uint256);
}

interface ICurriculumMinting {
    function mintCurriculum(address steward, string memory scrollType) external returns (bool);
    function isCurriculumMinted(address steward, string memory scrollType) external view returns (bool);
}

interface IEmotionRouter {
    function routeEmotion(address steward, string memory gridTag, uint256 aura) external returns (bool);
}

contract BankFusionDAOv14 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
        uint256 auraBalance;
        uint256 treatyWeight;
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
        string gridTag;
    }

    mapping(address => BankNode) public bankNodes;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    address public auraStaking;
    address public treatyReallocator;
    address public curriculumMinting;
    address public emotionRouter;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event AuraStaked(address indexed steward, uint256 amount);
    event TreatyReallocated(address indexed steward, string treatyTag, uint256 aura);
    event CurriculumMinted(address indexed steward, string scrollType);
    event EmotionRouted(address indexed steward, string gridTag, uint256 aura);
    event ProposalCreated(uint256 indexed id, string description, string scrollType);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);

    modifier onlyMintedCurriculum(string memory scrollType) {
        require(ICurriculumMinting(curriculumMinting).isCurriculumMinted(msg.sender, scrollType), "Curriculum not minted");
        _;
    }

    constructor(
        address _auraStaking,
        address _treatyReallocator,
        address _curriculumMinting,
        address _emotionRouter
    ) {
        auraStaking = _auraStaking;
        treatyReallocator = _treatyReallocator;
        curriculumMinting = _curriculumMinting;
        emotionRouter = _emotionRouter;
    }

    // 🏦 Register bank node with aura and treaty weight
    function registerBankNode(string memory name, string memory jurisdiction, string memory treatyTag) external {
        uint256 aura = IAuraStaking(auraStaking).getAuraBalance(msg.sender);
        uint256 weight = ITreatyReallocator(treatyReallocator).getTreatyWeight(msg.sender, treatyTag);
        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, aura, weight, aura + weight);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
    }

    // 💖 Stake aura for emotional governance
    function stakeAura(uint256 amount) external {
        require(bankNodes[msg.sender].isActive, "Inactive node");
        require(IAuraStaking(auraStaking).stakeAura(msg.sender, amount), "Stake failed");
        bankNodes[msg.sender].auraBalance += amount;
        bankNodes[msg.sender].votingPower += amount;
        emit AuraStaked(msg.sender, amount);
    }

    // 📜 Mint curriculum scroll
    function mintCurriculum(string memory scrollType) external {
        require(ICurriculumMinting(curriculumMinting).mintCurriculum(msg.sender, scrollType), "Mint failed");
        emit CurriculumMinted(msg.sender, scrollType);
    }

    // 🔁 Reallocate treaty blessings
    function reallocateTreaty(string memory treatyTag, uint256 aura) external {
        require(ITreatyReallocator(treatyReallocator).reallocateTreaty(msg.sender, treatyTag, aura), "Reallocation failed");
        bankNodes[msg.sender].treatyWeight += aura;
        bankNodes[msg.sender].votingPower += aura;
        emit TreatyReallocated(msg.sender, treatyTag, aura);
    }

    // 📡 Route emotion to grid
    function routeEmotion(string memory gridTag, uint256 aura) external {
        require(IEmotionRouter(emotionRouter).routeEmotion(msg.sender, gridTag, aura), "Routing failed");
        emit EmotionRouted(msg.sender, gridTag, aura);
    }

    // 📜 Create scroll proposal
    function createProposal(string memory description, string memory scrollType, string memory treatyTag, string memory gridTag, uint256 quorum) external onlyMintedCurriculum(scrollType) {
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
            treatyTag: treatyTag,
            gridTag: gridTag
        });

        emit ProposalCreated(proposalCount, description, scrollType);
    }

    // 🗳️ Vote with aura + treaty weight
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
