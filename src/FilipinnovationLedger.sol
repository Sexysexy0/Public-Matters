// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

contract FilipinnovationLedger {
    address public admin;
    bool public active;

    struct Innovator {
        address wallet;
        string name;
        string category;
        string company;
        string description;
        bool verified;
        uint256 timestamp;
        string ipfsHash;
    }

    struct Grant {
        uint256 id;
        address innovator;
        string projectName;
        uint256 amount;
        uint256 awardedDate;
        uint256 disbursedAmount;
        bool fullyDisbursed;
        string milestone;
        uint256 timestamp;
        string ipfsHash;
    }

    struct Commercialization {
        uint256 id;
        uint256 grantId;
        string productName;
        string market;
        uint256 revenue;
        bool launched;
        uint256 launchDate;
        string notes;
        uint256 timestamp;
        string ipfsHash;
    }

    struct ImpactEvent {
        uint256 id;
        string eventType;
        string description;
        uint256 score;
        uint256 timestamp;
        string ipfsHash;
        address proposer;
    }

    struct Vote {
        uint256 id;
        uint256 targetId;
        string targetType;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 startBlock;
        uint256 endBlock;
        bool executed;
        bool passed;
        address proposer;
    }

    Innovator[] public innovators;
    Grant[] public grants;
    Commercialization[] public commercializations;
    ImpactEvent[] public impactEvents;
    Vote[] public votes;

    mapping(address => bool) public isVerifiedInnovator;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event InnovatorRegistered(address indexed wallet, string name, string category);
    event GrantAwarded(uint256 indexed id, address innovator, uint256 amount);
    event GrantDisbursed(uint256 indexed id, uint256 amount);
    event CommercializationLogged(uint256 indexed id, uint256 grantId, string productName);
    event ImpactEventLogged(uint256 indexed id, string eventType, uint256 score);
    event VoteCast(uint256 indexed id, address voter, bool support);
    event VoteExecuted(uint256 indexed id, bool passed);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    modifier onlyVerifiedInnovator() {
        require(isVerifiedInnovator[msg.sender], "Not a verified innovator");
        _;
    }

    constructor() {
        admin = msg.sender;
        active = true;
    }

    // --- Voting ---

    function createVote(uint256 _targetId, string memory _targetType, uint256 _durationBlocks)
        public
        onlyAdmin
        whenActive
    {
        require(_durationBlocks > 0, "Duration must be > 0");

        uint256 id = votes.length;
        votes.push(
            Vote({
                id: id,
                targetId: _targetId,
                targetType: _targetType,
                votesFor: 0,
                votesAgainst: 0,
                startBlock: block.number,
                endBlock: block.number + _durationBlocks,
                executed: false,
                passed: false,
                proposer: msg.sender
            })
        );
    }

    function castVote(uint256 _voteId, bool _support) public whenActive {
        require(_voteId < votes.length, "Invalid vote");
        require(!hasVoted[_voteId][msg.sender], "Already voted");
        require(block.number < votes[_voteId].endBlock, "Voting ended");

        hasVoted[_voteId][msg.sender] = true;
        if (_support) {
            votes[_voteId].votesFor++;
        } else {
            votes[_voteId].votesAgainst++;
        }

        emit VoteCast(_voteId, msg.sender, _support);
    }

    function executeVote(uint256 _voteId) public onlyAdmin whenActive {
        require(_voteId < votes.length, "Invalid vote");
        require(!votes[_voteId].executed, "Already executed");
        require(block.number >= votes[_voteId].endBlock, "Voting still active");

        votes[_voteId].executed = true;
        votes[_voteId].passed = votes[_voteId].votesFor > votes[_voteId].votesAgainst;

        emit VoteExecuted(_voteId, votes[_voteId].passed);
    }

    // --- Innovator, Grant, Commercialization, ImpactEvent functions ---

    function registerInnovator(
        address _wallet,
        string calldata _name,
        string calldata _category,
        string calldata _company,
        string calldata _description,
        string calldata _ipfsHash
    ) external onlyAdmin whenActive {
        require(_wallet != address(0), "wallet=0");
        require(!isVerifiedInnovator[_wallet], "Already verified");

        isVerifiedInnovator[_wallet] = true;

        innovators.push(Innovator({
            wallet:      _wallet,
            name:        _name,
            category:    _category,
            company:     _company,
            description: _description,
            verified:    true,
            timestamp:   block.timestamp,
            ipfsHash:    _ipfsHash
        }));

        emit InnovatorRegistered(_wallet, _name, _category);
    }

    function awardGrant(
        address _innovator,
        string calldata _projectName,
        uint256 _amount,
        string calldata _milestone,
        string calldata _ipfsHash
    ) external onlyAdmin whenActive returns (uint256) {
        require(_innovator != address(0), "innovator=0");
        require(isVerifiedInnovator[_innovator], "Not verified");
        require(_amount > 0, "amount=0");

        uint256 id = grants.length;
        grants.push(Grant({
            id:              id,
            innovator:       _innovator,
            projectName:     _projectName,
            amount:          _amount,
            awardedDate:     block.timestamp,
            disbursedAmount: 0,
            fullyDisbursed:  false,
            milestone:       _milestone,
            timestamp:       block.timestamp,
            ipfsHash:        _ipfsHash
        }));

        emit GrantAwarded(id, _innovator, _amount);
        return id;
    }

    function disburseGrant(uint256 _grantId, uint256 _amount) external onlyAdmin whenActive {
        require(_grantId < grants.length, "Grant not found");
        Grant storage g = grants[_grantId];
        require(!g.fullyDisbursed, "Already fully disbursed");
        require(g.disbursedAmount + _amount <= g.amount, "Exceeds grant amount");

        g.disbursedAmount += _amount;
        if (g.disbursedAmount == g.amount) {
            g.fullyDisbursed = true;
        }

        emit GrantDisbursed(_grantId, _amount);
    }

    function logCommercialization(
        uint256 _grantId,
        string calldata _productName,
        string calldata _market,
        uint256 _revenue,
        string calldata _notes,
        string calldata _ipfsHash
    ) external onlyAdmin whenActive returns (uint256) {
        require(_grantId < grants.length, "Grant not found");

        uint256 id = commercializations.length;
        commercializations.push(Commercialization({
            id:          id,
            grantId:     _grantId,
            productName: _productName,
            market:      _market,
            revenue:     _revenue,
            launched:    true,
            launchDate:  block.timestamp,
            notes:       _notes,
            timestamp:   block.timestamp,
            ipfsHash:    _ipfsHash
        }));

        emit CommercializationLogged(id, _grantId, _productName);
        return id;
    }

    function logImpactEvent(
        string calldata _eventType,
        string calldata _description,
        uint256 _score,
        string calldata _ipfsHash
    ) external onlyAdmin whenActive returns (uint256) {
        uint256 id = impactEvents.length;
        impactEvents.push(ImpactEvent({
            id:          id,
            eventType:   _eventType,
            description: _description,
            score:       _score,
            timestamp:   block.timestamp,
            ipfsHash:    _ipfsHash,
            proposer:    msg.sender
        }));

        emit ImpactEventLogged(id, _eventType, _score);
        return id;
    }


    // --- Convenience getters ---

    function innovatorsLength() external view returns (uint256) { return innovators.length; }
    function grantsLength() external view returns (uint256) { return grants.length; }
    function commercializationsLength() external view returns (uint256) { return commercializations.length; }
    function impactEventsLength() external view returns (uint256) { return impactEvents.length; }
    function votesLength() external view returns (uint256) { return votes.length; }

}
