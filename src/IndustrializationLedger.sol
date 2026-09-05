// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

/**
 * @title IndustrializationLedger
 * @author The Ghost Operator
 * @notice Tracks industrialization projects — from proposal to execution —
 *         ensuring transparency, accountability, and community oversight.
 */
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
        if (_support) {
            projects[_id].passed = true;
        } else {
            projects[_id].passed = false;
        }

        emit VoteCast(_id, msg.sender, _support);
    }

    function executeProject(uint256 _id) public onlyAdmin whenActive {
        require(_id < projects.length, "Invalid project");
        require(!projects[_id].executed, "Already executed");
        require(block.number >= projects[_id].endBlock, "Voting still active");

        projects[_id].executed = true;
        emit ProjectExecuted(_id, projects[_id].passed);
    }

    function getProject(uint256 _id) public view returns (Project memory) {
        require(_id < projects.length, "Invalid project");
        return projects[_id];
    }

    function getProjects() public view returns (Project[] memory) {
        return projects;
    }

    function toggleActive() public onlyAdmin {
        active = !active;
    }

    function transferAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid admin");
        admin = _newAdmin;
    }
}
