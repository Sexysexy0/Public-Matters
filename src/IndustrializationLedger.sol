// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

contract IndustrializationLedger {
    address public admin;
    bool public active;

    struct Project {
        uint256 id;
        string name;
        string sector;
        uint256 budget;
        uint256 startBlock;
        uint256 endBlock;
        bool executed;
        bool passed;
        string ipfsHash;
        address proposer;
    }

    Project[] public projects;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => uint256) public votesFor; // NEW: proper tally
    mapping(uint256 => uint256) public votesAgainst; // NEW: proper tally

    event ProjectRegistered(uint256 indexed id, string name, string sector);
    event VoteCast(uint256 indexed id, address voter, bool support);
    event ProjectExecuted(uint256 indexed id, bool passed);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    constructor() {
        admin = msg.sender;
        active = true;
    }

    function registerProject(
        string memory _name,
        string memory _sector,
        uint256 _budget,
        uint256 _durationBlocks,
        string memory _ipfsHash
    ) public onlyAdmin whenActive {
        require(_budget > 0, "Budget must be > 0");
        require(_durationBlocks > 0, "Duration must be > 0");
        require(bytes(_name).length > 0, "Name empty"); // NEW: validation
        require(bytes(_sector).length > 0, "Sector empty"); // NEW: validation

        uint256 id = projects.length;
        projects.push(
            Project({
                id: id,
                name: _name,
                sector: _sector,
                budget: _budget,
                startBlock: block.number,
                endBlock: block.number + _durationBlocks,
                executed: false,
                passed: false,
                ipfsHash: _ipfsHash,
                proposer: msg.sender
            })
        );

        emit ProjectRegistered(id, _name, _sector);
    }

    function castVote(uint256 _id, bool _support) public whenActive {
        require(_id < projects.length, "Invalid project");
        require(!hasVoted[_id][msg.sender], "Already voted");
        require(block.number < projects[_id].endBlock, "Voting ended");

        hasVoted[_id][msg.sender] = true;

        // NEW: Proper vote tallying
        if (_support) {
            votesFor[_id]++;
        } else {
            votesAgainst[_id]++;
        }

        emit VoteCast(_id, msg.sender, _support);
    }

    function executeProject(uint256 _id) public onlyAdmin whenActive {
        require(_id < projects.length, "Invalid project");
        require(!projects[_id].executed, "Already executed");
        require(block.number >= projects[_id].endBlock, "Voting still active");

        // NEW: Check vote results
        projects[_id].passed = votesFor[_id] > votesAgainst[_id];
        projects[_id].executed = true;

        emit ProjectExecuted(_id, projects[_id].passed);
    }

    function getProject(uint256 _id) public view returns (Project memory) {
        require(_id < projects.length, "Invalid project");
        return projects[_id];
    }

    function getProjectsCount() public view returns (uint256) {
        // NEW: gas-efficient
        return projects.length;
    }

    function toggleActive() public onlyAdmin {
        active = !active;
    }

    function transferAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid admin");
        admin = _newAdmin;
    }

    function getVoteResults(uint256 _id) public view returns (uint256, uint256) {
        // NEW: helper
        require(_id < projects.length, "Invalid project");
        return (votesFor[_id], votesAgainst[_id]);
    }
}
