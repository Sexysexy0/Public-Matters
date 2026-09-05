// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

/**
 * @title FilipinnovationLedger
 * @author The Ghost Operator
 * @notice A covenant contract that tracks Filipino innovation projects —
 *         from grant award to commercialization — with full transparency,
 *         accountability, and community oversight.
 */
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
        uint256 startTime;
        uint256 endTime;
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

    function registerInnovator(
        string memory _name,
        string memory _category,
        string memory _company,
        string memory _description,
        string memory _ipfsHash
    ) public whenActive {
        require(bytes(_name).length > 0, "Name required");
        require(bytes(_category).length > 0, "Category required");
        require(!isVerifiedInnovator[msg.sender], "Already registered");

        innovators.push(Innovator({
            wallet: msg.sender,
            name: _name,
            category: _category,
            company: _company,
            description: _description,
            verified: false,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash
        }));

        emit InnovatorRegistered(msg.sender, _name, _category);
    }

    function verifyInnovator(address _wallet) public onlyAdmin whenActive {
        require(_wallet != address(0), "Invalid wallet");
        require(!isVerifiedInnovator[_wallet], "Already verified");

        for (uint i = 0; i < innovators.length; i++) {
            if (innovators[i].wallet == _wallet) {
                innovators[i].verified = true;
                isVerifiedInnovator[_wallet] = true;
                break;
            }
        }
    }

    function getInnovator(address _wallet) public view returns (Innovator memory) {
        for (uint i = 0; i < innovators.length; i++) {
            if (innovators[i].wallet == _wallet) {
                return innovators[i];
            }
        }
        revert("Innovator not found");
    }

    function getInnovators() public view returns (Innovator[] memory) {
        return innovators;
    }

    function awardGrant(
        address _innovator,
        string memory _projectName,
        uint256 _amount,
        string memory _milestone,
        string memory _ipfsHash
    ) public onlyAdmin whenActive {
        require(isVerifiedInnovator[_innovator], "Innovator not verified");
        require(_amount > 0, "Amount must be > 0");

        uint256 id = grants.length;
        grants.push(Grant({
            id: id,
            innovator: _innovator,
            projectName: _projectName,
            amount: _amount,
            awardedDate: block.timestamp,
            disbursedAmount: 0,
            fullyDisbursed: false,
            milestone: _milestone,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash
        }));

        emit GrantAwarded(id, _innovator, _amount);
    }

    function disburseGrant(uint256 _id, uint256 _amount) public onlyAdmin whenActive {
        require(_id < grants.length, "Invalid grant");
        Grant storage g = grants[_id];
        require(g.disbursedAmount + _amount <= g.amount, "Exceeds grant amount");

        g.disbursedAmount += _amount;
        if (g.disbursedAmount == g.amount) {
            g.fullyDisbursed = true;
        }

        emit GrantDisbursed(_id, _amount);
    }

    function getGrant(uint256 _id) public view returns (Grant memory) {
        require(_id < grants.length, "Invalid grant");
        return grants[_id];
    }

    function getGrants() public view returns (Grant[] memory) {
        return grants;
    }

    function logCommercialization(
        uint256 _grantId,
        string memory _productName,
        string memory _market,
        uint256 _revenue,
        string memory _notes,
        string memory _ipfsHash
    ) public onlyVerifiedInnovator whenActive {
        require(_grantId < grants.length, "Invalid grant");
        require(bytes(_productName).length > 0, "Product name required");

        uint256 id = commercializations.length;
        commercializations.push(Commercialization({
            id: id,
            grantId: _grantId,
            productName: _productName,
            market: _market,
            revenue: _revenue,
            launched: false,
            launchDate: 0,
            notes: _notes,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash
        }));

        emit CommercializationLogged(id, _grantId, _productName);
    }

    function markLaunched(uint256 _id) public onlyVerifiedInnovator whenActive {
        require(_id < commercializations.length, "Invalid commercialization");
        commercializations[_id].launched = true;
        commercializations[_id].launchDate = block.timestamp;
    }

    function getCommercialization(uint256 _id) public view returns (Commercialization memory) {
        require(_id < commercializations.length, "Invalid commercialization");
        return commercializations[_id];
    }

    function getCommercializations() public view returns (Commercialization[] memory) {
        return commercializations;
    }

    function logImpactEvent(
        string memory _eventType,
        string memory _description,
        uint256 _score,
        string memory _ipfsHash
    ) public onlyAdmin whenActive {
        require(_score <= 100, "Score must be <= 100");

        uint256 id = impactEvents.length;
        impactEvents.push(ImpactEvent({
            id: id,
            eventType: _eventType,
            description: _description,
            score: _score,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash,
            proposer: msg.sender
        }));

        emit ImpactEventLogged(id, _eventType, _score);
    }

    function getImpactEvents() public view returns (ImpactEvent[] memory) {
        return impactEvents;
    }

    function createVote(
        uint256 _targetId,
        string memory _targetType,
        uint256 _duration
    ) public onlyAdmin whenActive {
        require(_duration > 0, "Duration must be > 0");

        uint256 id = votes.length;
        votes.push(Vote({
            id: id,
            targetId: _targetId,
            targetType: _targetType,
            votesFor: 0,
            votesAgainst: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + _duration,
            executed: false,
            passed: false,
            proposer: msg.sender
        }));
    }

    function castVote(uint256 _voteId, bool _support) public whenActive {
        require(_voteId < votes.length, "Invalid vote");
        require(!hasVoted[_voteId][msg.sender], "Already voted");
        require(block.timestamp < votes[_voteId].endTime, "Voting ended");

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
        require(block.timestamp >= votes[_voteId].endTime, "Voting still active");

        votes[_voteId].executed = true;
        votes[_voteId].passed = votes[_voteId].votesFor > votes[_voteId].votesAgainst;

        emit VoteExecuted(_voteId, votes[_voteId].passed);
    }

    function getVote(uint256 _id) public view returns (Vote memory) {
        require(_id < votes.length, "Invalid vote");
        return votes[_id];
    }

    function toggleActive() public onlyAdmin {
        active = !active;
    }

    function transferAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid admin");
        admin = _newAdmin;
    }
}
