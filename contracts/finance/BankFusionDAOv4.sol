// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAPROracle {
    function getAPR(address steward) external view returns (uint256);
}

interface IProphecyFeed {
    function isTriggered(string memory tag) external view returns (bool);
}

interface IAIValidator {
    function validateProposal(string memory description, string memory prophecyTag) external view returns (bool);
}

interface ITreasuryRouter {
    function routeBlessing(address bank, uint256 amount, string memory gridTag) external returns (bool);
}

contract BankFusionDAOv4 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
        uint256 votingPower;
        uint256 stakedAPR;
        uint256 yieldBalance;
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
        string prophecyTag;
        string gridTag;
    }

    mapping(address => BankNode) public bankNodes;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    uint256 public blessingPool;

    address public aprOracle;
    address public prophecyFeed;
    address public aiValidator;
    address public treasuryRouter;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event APRStaked(address indexed node, uint256 amount);
    event YieldHarvested(address indexed node, uint256 amount);
    event ProposalCreated(uint256 indexed id, string description, string prophecyTag, string gridTag);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);
    event BlessingRouted(address indexed bank, uint256 amount, string gridTag);

    modifier onlyActiveNode() {
        require(bankNodes[msg.sender].isActive, "Inactive bank node");
        _;
    }

    constructor(address _aprOracle, address _prophecyFeed, address _aiValidator, address _treasuryRouter) {
        aprOracle = _aprOracle;
        prophecyFeed = _prophecyFeed;
        aiValidator = _aiValidator;
        treasuryRouter = _treasuryRouter;
    }

    // 🏦 Register bank node with emotional APR
    function registerBankNode(string memory name, string memory jurisdiction) external {
        uint256 apr = IAPROracle(aprOracle).getAPR(msg.sender);
        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, apr, 0, 0);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
    }

    // 💖 Stake APR to boost voting power and yield
    function stakeAPR(uint256 amount) external onlyActiveNode {
        bankNodes[msg.sender].stakedAPR += amount;
        bankNodes[msg.sender].votingPower += amount;
        bankNodes[msg.sender].yieldBalance += amount / 10; // Simulated yield
        emit APRStaked(msg.sender, amount);
    }

    // 🌾 Harvest emotional yield
    function harvestYield() external onlyActiveNode {
        uint256 yield = bankNodes[msg.sender].yieldBalance;
        require(yield > 0, "No yield");
        bankNodes[msg.sender].yieldBalance = 0;
        payable(msg.sender).transfer(yield);
        emit YieldHarvested(msg.sender, yield);
    }

    // 📜 Create AI-validated, prophecy-tagged proposal
    function createProposal(string memory description, string memory prophecyTag, string memory gridTag, uint256 quorum) external onlyActiveNode {
        require(IProphecyFeed(prophecyFeed).isTriggered(prophecyTag), "Prophecy not triggered");
        require(IAIValidator(aiValidator).validateProposal(description, prophecyTag), "AI rejected proposal");

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
            prophecyTag: prophecyTag,
            gridTag: gridTag
        });

        emit ProposalCreated(proposalCount, description, prophecyTag, gridTag);
    }

    // 🗳️ Vote with emotional power
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

    // 🧠 Execute proposal and route blessings
    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.deadline, "Voting still active");
        require(!proposal.executed, "Already executed");
        require(proposal.voteYes + proposal.voteNo >= proposal.quorum, "Quorum not met");
        require(IProphecyFeed(prophecyFeed).isTriggered(proposal.prophecyTag), "Prophecy expired");

        if (proposal.voteYes > proposal.voteNo) {
            proposal.executed = true;
            bool success = ITreasuryRouter(treasuryRouter).routeBlessing(proposal.proposer, proposal.voteYes, proposal.gridTag);
            require(success, "Blessing routing failed");
            emit ProposalExecuted(proposalId);
            emit BlessingRouted(proposal.proposer, proposal.voteYes, proposal.gridTag);
        }
    }

    // 💸 Fund blessing pool
    function fundBlessingPool() external payable {
        blessingPool += msg.value;
    }
}
