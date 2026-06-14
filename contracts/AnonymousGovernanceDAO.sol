// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AnonymousGovernanceDAO {
    address public rootKing;

    struct Proposal {
        uint256 id;
        string description;  // Halimbawa: "I-freeze ang Institution X dahil sa YouTube scandal"
        address targetContract;
        bytes transactionData;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
        bool vetoed;
        uint256 deadline;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public councilMembers;
    // Proposal ID => Member => Boto Status
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed id, string description, uint256 deadline);
    event Voted(uint256 indexed id, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed id);
    event ProposalVetoed(uint256 indexed id);

    modifier onlyKing() {
        require(msg.sender == rootKing, "Error: Sovereign denial. Only the King holds this power.");
        _;
    }

    modifier onlyCouncil() {
        require(councilMembers[msg.sender] || msg.sender == rootKing, "Error: Access denied. Not a Shadow Council member.");
        _;
    }

    constructor() {
        rootKing = msg.sender;
        councilMembers[msg.sender] = true; // Ang King ang unang miyembro ng konseho
    }

    // Magdagdag ng pinagkakatiwalaang agent o wallet sa iyong Shadow Council
    function addCouncilMember(address _member) public onlyKing {
        councilMembers[_member] = true;
    }

    // Tanggalin ang isang miyembro kung hindi na mapagkakatiwalaan
    function removeCouncilMember(address _member) public onlyKing {
        councilMembers[_member] = false;
    }

    // Ang sinumang miyembro ng konseho ay pwedeng maghain ng mungkahi para sa system improvement
    function createProposal(
        string memory _description,
        address _target,
        bytes memory _data,
        uint256 _votingDurationSeconds
    ) public onlyCouncil returns (uint256) {
        proposalCount++;
        
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: _description,
            targetContract: _target,
            transactionData: _data,
            votesFor: 0,
            votesAgainst: 0,
            executed: false,
            vetoed: false,
            deadline: block.timestamp + _votingDurationSeconds
        });

        emit ProposalCreated(proposalCount, _description, block.timestamp + _votingDurationSeconds);
        return proposalCount;
    }

    // Bumoto para sa isang aktibong mungkahi
    function vote(uint256 _proposalId, bool _support) public onlyCouncil {
        Proposal storage prop = proposals[_proposalId];
        require(block.timestamp <= prop.deadline, "Error: Voting period has ended.");
        require(!hasVoted[_proposalId][msg.sender], "Error: You have already cast your vote.");

        hasVoted[_proposalId][msg.sender] = true;

        if (_support) {
            prop.votesFor++;
        } else {
            prop.votesAgainst++;
        }

        emit Voted(_proposalId, msg.sender, _support);
    }

    // I-execute ang proposal kung pumasa sa mayorya ng konseho matapos ang deadline
    function executeProposal(uint256 _proposalId) public onlyCouncil {
        Proposal storage prop = proposals[_proposalId];
        require(block.timestamp > prop.deadline, "Error: Voting is still ongoing.");
        require(!prop.executed, "Error: Proposal already executed.");
        require(!prop.vetoed, "Error: This proposal has been vetoed.");
        require(prop.votesFor > prop.votesAgainst, "Error: Proposal did not pass majority vote.");

        prop.executed = true;

        // Isagawa ang nakatalagang transaksyon on-chain
        (bool success, ) = prop.targetContract.call(prop.transactionData);
        require(success, "Error: Internal transaction execution failed.");

        emit ProposalExecuted(_proposalId);
    }

    // Ang Absolute Veto: Pwedeng patayin ng King ang kahit anong proposal anumang oras
    function sovereignVeto(uint256 _proposalId) public onlyKing {
        Proposal storage prop = proposals[_proposalId];
        require(!prop.executed, "Error: Cannot veto an already executed proposal.");
        
        prop.vetoed = true;
        emit ProposalVetoed(_proposalId);
    }
}
