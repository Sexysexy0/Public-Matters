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
        uint256 areaHectares; // Proposed area in hectares
        uint256 estimatedCost; // In wei (or stablecoin)
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 startTime;
        uint256 endTime;
        bool executed;
        bool passed;
        address proposer;
        string ipfsHash; // Link to full technical docs
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
        // Auto-register admin as validator
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
        uint256 _votingDuration,
        string memory _ipfsHash
    ) public onlyValidator whenActive {
        require(_areaHectares > 0, "Area must be > 0");
        require(_votingDuration > 0, "Duration must be > 0");

        uint256 proposalId = proposalCount;
        proposals[proposalId] = ImpoundingProposal({
            id: proposalId,
            title: _title,
            description: _description,
            areaHectares: _areaHectares,
            estimatedCost: _estimatedCost,
            votesFor: 0,
            votesAgainst: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + _votingDuration,
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
        // forgefmt: disable-next-line
        // solhint-disable-next-line
        require(block.timestamp < proposals[_proposalId].endTime, "Voting ended");

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
        // forgefmt: disable-next-line
        // solhint-disable-next-line
        require(!proposals[_proposalId].executed, "Already executed");
        require(block.timestamp >= proposals[_proposalId].endTime, "Voting still active");

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
