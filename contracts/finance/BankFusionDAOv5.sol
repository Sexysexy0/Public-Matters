// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAPROracle {
    function getAPR(address steward) external view returns (uint256);
}

interface IAIAvatar {
    function validateScroll(address steward, string memory scrollType) external view returns (bool);
}

interface ILiquidityPool {
    function depositAPR(address steward, uint256 amount) external returns (bool);
    function withdrawYield(address steward) external returns (uint256);
}

interface ITreatyRegistry {
    function isTreatyCompliant(address steward) external view returns (bool);
}

contract BankFusionDAOv5 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
        uint256 votingPower;
        uint256 stakedAPR;
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
    }

    mapping(address => BankNode) public bankNodes;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    uint256 public blessingPool;

    address public aprOracle;
    address public aiAvatar;
    address public liquidityPool;
    address public treatyRegistry;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event APRStaked(address indexed node, uint256 amount);
    event ProposalCreated(uint256 indexed id, string description, string scrollType);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);
    event BlessingDistributed(address indexed bank, uint256 amount);

    modifier onlyTreatyCompliant() {
        require(ITreatyRegistry(treatyRegistry).isTreatyCompliant(msg.sender), "Not treaty-compliant");
        _;
    }

    constructor(address _aprOracle, address _aiAvatar, address _liquidityPool, address _treatyRegistry) {
        aprOracle = _aprOracle;
        aiAvatar = _aiAvatar;
        liquidityPool = _liquidityPool;
        treatyRegistry = _treatyRegistry;
    }

    // 🏦 Register bank node with treaty-grade onboarding
    function registerBankNode(string memory name, string memory jurisdiction) external onlyTreatyCompliant {
        uint256 apr = IAPROracle(aprOracle).getAPR(msg.sender);
        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, apr, 0, apr / 100);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
    }

    // 💖 Stake APR into liquidity pool
    function stakeAPR(uint256 amount) external {
        require(bankNodes[msg.sender].isActive, "Inactive node");
        require(ILiquidityPool(liquidityPool).depositAPR(msg.sender, amount), "Deposit failed");
        bankNodes[msg.sender].stakedAPR += amount;
        bankNodes[msg.sender].votingPower += amount;
        emit APRStaked(msg.sender, amount);
    }

    // 🌾 Harvest yield from emotional APR pool
    function harvestYield() external {
        uint256 yield = ILiquidityPool(liquidityPool).withdrawYield(msg.sender);
        require(yield > 0, "No yield");
        payable(msg.sender).transfer(yield);
    }

    // 📜 Create scroll-type proposal validated by AI avatar
    function createProposal(string memory description, string memory scrollType, uint256 quorum) external {
        require(bankNodes[msg.sender].isActive, "Inactive node");
        require(IAIAvatar(aiAvatar).validateScroll(msg.sender, scrollType), "Scroll rejected");

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

    // 🗳️ Vote with treaty-weighted power
    function vote(uint256 proposalId, bool support) external {
        require(bankNodes[msg.sender].isActive, "Inactive node");
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp < proposal.deadline, "Voting closed");

        uint256 power = bankNodes[msg.sender].votingPower + bankNodes[msg.sender].treatyScore;

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

    // 💸 Blessing pool rituals
    function fundBlessingPool() external payable {
        blessingPool += msg.value;
    }

    function distributeBlessings(address[] memory banks, uint256[] memory amounts) external {
        require(banks.length == amounts.length, "Mismatch");
        for (uint256 i = 0; i < banks.length; i++) {
            require(blessingPool >= amounts[i], "Insufficient pool");
            blessingPool -= amounts[i];
            payable(banks[i]).transfer(amounts[i]);
            emit BlessingDistributed(banks[i], amounts[i]);
        }
    }
}
