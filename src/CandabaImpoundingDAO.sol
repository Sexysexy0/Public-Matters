// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

/**
 * @title CandabaImpoundingDAO
 * @author The Source
 * @notice On-chain governance for the Candaba Swamp impounding project.
 * @dev Manages proposals, voting, and execution of the flood control solution.
 */
contract CandabaImpoundingDAO {
    address public admin;
    bool public active;
    uint256 public proposalCount;

    struct ImpoundingProposal {
        uint256 id;
        string title;
        string description;
        uint256 areaHectares;
        uint256 estimatedCost;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 startBlock;
        uint256 endBlock;
        bool executed;
        bool passed;
        address proposer;
        string ipfsHash;
    }

    mapping(uint256 => ImpoundingProposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(address => bool) public isValidator;

    event ProposalCreated(uint256 indexed id, string title, uint256 areaHectares);
    event VoteCast(uint256 indexed id, address voter, bool support);
    event ProposalExecuted(uint256 indexed id, bool passed);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    modifier onlyValidator() {
        require(isValidator[msg.sender], "Not a validator");
        _;
    }

    constructor() {
        admin = msg.sender;
        active = true;
        proposalCount = 0;
        isValidator[msg.sender] = true;
    }

    function addValidator(address _validator) public onlyAdmin whenActive {
        isValidator[_validator] = true;
    }

    function removeValidator(address _validator) public onlyAdmin whenActive {
        isValidator[_validator] = false;
    }

    function createProposal(
        string memory _title,
        string memory _description,
        uint256 _areaHectares,
        uint256 _estimatedCost,
        uint256 _durationBlocks,
        string memory _ipfsHash
    ) public onlyValidator whenActive {
        require(_areaHectares > 0, "Area must be > 0");
        require(_durationBlocks > 0, "Duration must be > 0");

        uint256 proposalId = proposalCount;
        proposals[proposalId] = ImpoundingProposal({
            id: proposalId,
            title: _title,
            description: _description,
            areaHectares: _areaHectares,
            estimatedCost: _estimatedCost,
            votesFor: 0,
            votesAgainst: 0,
            startBlock: block.number,
            endBlock: block.number + _durationBlocks,
            executed: false,
            passed: false,
            proposer: msg.sender,
            ipfsHash: _ipfsHash
        });

        proposalCount++;
        emit ProposalCreated(proposalId, _title, _areaHectares);
    }

    function vote(uint256 _proposalId, bool _support) public onlyValidator whenActive {
        require(_proposalId < proposalCount, "Invalid proposal");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");
        require(block.number < proposals[_proposalId].endBlock, "Voting ended");

        hasVoted[_proposalId][msg.sender] = true;
        if (_support) {
            proposals[_proposalId].votesFor++;
        } else {
            proposals[_proposalId].votesAgainst++;
        }

        emit VoteCast(_proposalId, msg.sender, _support);
    }

    function executeProposal(uint256 _proposalId) public onlyAdmin whenActive {
        require(_proposalId < proposalCount, "Invalid proposal");
        require(!proposals[_proposalId].executed, "Already executed");
        require(block.number >= proposals[_proposalId].endBlock, "Voting still active");

        proposals[_proposalId].executed = true;
        proposals[_proposalId].passed = proposals[_proposalId].votesFor > proposals[_proposalId].votesAgainst;

        emit ProposalExecuted(_proposalId, proposals[_proposalId].passed);
    }

    function getProposal(uint256 _proposalId) public view returns (ImpoundingProposal memory) {
        require(_proposalId < proposalCount, "Invalid proposal");
        return proposals[_proposalId];
    }

    function getProposalCount() public view returns (uint256) {
        return proposalCount;
    }

    function toggleActive() public onlyAdmin {
        active = !active;
    }
}
