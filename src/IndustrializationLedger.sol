// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract IndustrializationLedger {
    address public admin;
    
    struct Project {
        string name;
        string sector;
        uint256 budget;
        uint256 capacity;
        string dataUri;
        bool active;
    }

    mapping(uint256 => Project) public projects;
    uint256 public projectCounter;

    event AdministrativeStewardshipTransferred(address indexed oldAdmin, address indexed newAdmin);
    event ProjectRegistered(uint256 indexed projectId, string name, string sector, uint256 budget);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function updateLedgerAuthority(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Zero-address configuration guard");
        address oldAdmin = admin;
        admin = _newAdmin;
        emit AdministrativeStewardshipTransferred(oldAdmin, _newAdmin);
    }

    // Restored the missing method with exact structural arguments required by the integration test
    function registerProject(
        string calldata _name,
        string calldata _sector,
        uint256 _budget,
        uint256 _capacity,
        string calldata _dataUri
    ) external onlyAdmin returns (uint256 projectId) {
        projectCounter++;
        projectId = projectCounter;

        projects[projectId] = Project({
            name: _name,
            sector: _sector,
            budget: _budget,
            capacity: _capacity,
            dataUri: _dataUri,
            active: true
        });

        emit ProjectRegistered(projectId, _name, _sector, _budget);
    }
}
