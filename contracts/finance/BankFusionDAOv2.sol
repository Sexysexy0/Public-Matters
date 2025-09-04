// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAPROracle {
    function getAPR(address steward) external view returns (uint256);
}

contract BankFusionDAOv2 {
    struct BankNode {
        string name;
        string jurisdiction;
        bool isActive;
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
        string prophecyTag;
    }

    mapping(address => BankNode) public bankNodes;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    uint256 public blessingPool;
    address public aprOracle;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event ProposalCreated(uint256 indexed id, string description, string prophecyTag, address proposer);
    event Voted(uint256 indexed proposalId, address voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);
    event BlessingDistributed(address indexed bank, uint256 amount);

    modifier onlyActiveNode() {
        require(bankNodes[msg.sender].isActive, "Inactive bank node");
        _;
    }

    constructor(address _aprOracle) {
        aprOracle = _aprOracle;
    }

    // 🏦 Register bank node with emotional APR-based voting power
    function registerBankNode(string memory name, string memory jurisdiction) external {
        uint256 apr = IAPROracle(aprOracle).getAPR(msg.sender);
        bankNodes[msg.sender] = BankNode(name, jurisdiction, true, apr);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
    }

    // 📜 Create proposal with prophecy tag and quorum threshold
    function createProposal(string memory description, string memory prophecyTag, uint256 quorum) external onlyActiveNode {
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
            prophecyTag: prophecyTag
        });
        emit ProposalCreated(proposalCount, description, prophecyTag, msg.sender);
    }

    // 🗳️ Vote with emotional APR-weighted power
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

    // 🧠 Execute proposal if quorum met and vote passes
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
