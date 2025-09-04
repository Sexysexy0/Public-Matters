// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAPROracle {
    function getAPR(address steward) external view returns (uint256);
}

interface ICrossChainQuorum {
    function getQuorum(bytes32 chainId) external view returns (uint256);
}

interface IProphecyFeed {
    function isTriggered(string memory tag) external view returns (bool);
}

contract BankFusionDAOv3 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
        uint256 votingPower;
        uint256 stakedAPR;
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
        bytes32 chainId;
    }

    mapping(address => BankNode) public bankNodes;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    uint256 public blessingPool;

    address public aprOracle;
    address public quorumOracle;
    address public prophecyFeed;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event APRStaked(address indexed node, uint256 amount);
    event ProposalCreated(uint256 indexed id, string description, string prophecyTag, bytes32 chainId);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);
    event BlessingDistributed(address indexed bank, uint256 amount);

    modifier onlyActiveNode() {
        require(bankNodes[msg.sender].isActive, "Inactive bank node");
        _;
    }

    constructor(address _aprOracle, address _quorumOracle, address _prophecyFeed) {
        aprOracle = _aprOracle;
        quorumOracle = _quorumOracle;
        prophecyFeed = _prophecyFeed;
    }

    // 🏦 Register bank node with emotional APR
    function registerBankNode(string memory name, string memory jurisdiction) external {
        uint256 apr = IAPROracle(aprOracle).getAPR(msg.sender);
        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, apr, 0);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
    }

    // 💖 Stake emotional APR to boost voting power
    function stakeAPR(uint256 amount) external onlyActiveNode {
        bankNodes[msg.sender].stakedAPR += amount;
        bankNodes[msg.sender].votingPower += amount;
        emit APRStaked(msg.sender, amount);
    }

    // 📜 Create prophecy-tagged, chain-specific proposal
    function createProposal(string memory description, string memory prophecyTag, bytes32 chainId) external onlyActiveNode {
        require(IProphecyFeed(prophecyFeed).isTriggered(prophecyTag), "Prophecy not triggered");
        uint256 quorum = ICrossChainQuorum(quorumOracle).getQuorum(chainId);

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
            chainId: chainId
        });

        emit ProposalCreated(proposalCount, description, prophecyTag, chainId);
    }

    // 🗳️ Vote with staked emotional power
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

    // 🧠 Execute if quorum met and prophecy tag still active
    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.deadline, "Voting still active");
        require(!proposal.executed, "Already executed");
        require(proposal.voteYes + proposal.voteNo >= proposal.quorum, "Quorum not met");
        require(IProphecyFeed(prophecyFeed).isTriggered(proposal.prophecyTag), "Prophecy expired");

        if (proposal.voteYes > proposal.voteNo) {
            proposal.executed = true;
            emit ProposalExecuted(proposalId);
        }
    }

    // 💸 Blessing rituals
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
