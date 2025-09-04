// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAPROracle {
    function getAPR(address steward) external view returns (uint256);
}

interface IKinderQueenValidator {
    function approveScroll(address steward, string memory scrollType) external view returns (bool);
}

interface IBitMarketTreaty {
    function verifyTreaty(address steward) external view returns (bool);
    function getTreatyScore(address steward) external view returns (uint256);
}

interface ICurriculumTrigger {
    function isLessonActive(string memory scrollType) external view returns (bool);
}

interface ITreasuryRouter {
    function routeBlessing(address steward, uint256 amount, string memory gridTag) external returns (bool);
}

contract BankFusionDAOv6 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
        uint256 votingPower;
        uint256 emotionalAPR;
        uint256 treatyScore;
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
    }

    mapping(address => BankNode) public bankNodes;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    uint256 public blessingPool;

    address public aprOracle;
    address public kinderQueenValidator;
    address public bitMarketTreaty;
    address public curriculumTrigger;
    address public treasuryRouter;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event ProposalCreated(uint256 indexed id, string description, string scrollType);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);
    event BlessingRouted(address indexed steward, uint256 amount, string gridTag);

    modifier onlyTreatySynced() {
        require(IBitMarketTreaty(bitMarketTreaty).verifyTreaty(msg.sender), "Treaty not verified");
        _;
    }

    constructor(
        address _aprOracle,
        address _kinderQueenValidator,
        address _bitMarketTreaty,
        address _curriculumTrigger,
        address _treasuryRouter
    ) {
        aprOracle = _aprOracle;
        kinderQueenValidator = _kinderQueenValidator;
        bitMarketTreaty = _bitMarketTreaty;
        curriculumTrigger = _curriculumTrigger;
        treasuryRouter = _treasuryRouter;
    }

    // 🏦 Register bank node with treaty sync and emotional APR
    function registerBankNode(string memory name, string memory jurisdiction) external onlyTreatySynced {
        uint256 apr = IAPROracle(aprOracle).getAPR(msg.sender);
        uint256 treatyScore = IBitMarketTreaty(bitMarketTreaty).getTreatyScore(msg.sender);
        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, apr + treatyScore, apr, treatyScore);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
    }

    // 📜 Create scroll proposal with curriculum and Kinder Queen validation
    function createProposal(
        string memory description,
        string memory scrollType,
        string memory gridTag,
        uint256 quorum
    ) external {
        require(bankNodes[msg.sender].isActive, "Inactive node");
        require(ICurriculumTrigger(curriculumTrigger).isLessonActive(scrollType), "Lesson not active");
        require(IKinderQueenValidator(kinderQueenValidator).approveScroll(msg.sender, scrollType), "Scroll rejected");

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
            gridTag: gridTag
        });

        emit ProposalCreated(proposalCount, description, scrollType);
    }

    // 🗳️ Vote with emotional APR + treaty score
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

    // 🧠 Execute scroll and route blessings
    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.deadline, "Voting still active");
        require(!proposal.executed, "Already executed");
        require(proposal.voteYes + proposal.voteNo >= proposal.quorum, "Quorum not met");

        if (proposal.voteYes > proposal.voteNo) {
            proposal.executed = true;
            bool success = ITreasuryRouter(treasuryRouter).routeBlessing(proposal.proposer, proposal.voteYes, proposal.gridTag);
            require(success, "Blessing routing failed");
            emit ProposalExecuted(proposalId);
            emit BlessingRouted(proposal.proposer, proposal.voteYes, proposal.gridTag);
        }
    }

    // 💸 Blessing pool rituals
    function fundBlessingPool() external payable {
        blessingPool += msg.value;
    }
}
