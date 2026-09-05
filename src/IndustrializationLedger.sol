// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

/**
 * @title IndustrializationLedger
 * @author The Ghost Operator
 * @notice A covenant contract that encodes industrialization, power governance,
 *         and fiscal discipline for the Philippines.
 * @dev Logs mineral value-add projects, infrastructure skepticism, energy policy reforms,
 *      governance failures, and resilience events.
 */
contract IndustrializationLedger {
    address public admin;
    bool public active;

    // ============================================================
    // STRUCTS
    // ============================================================

    struct MineralProject {
        uint256 id;
        string mineral; // nickel, copper, cobalt
        string projectName;
        string location;
        uint256 valueAdd; // percentage of value added (e.g., 70 = 70%)
        uint256 investmentAmount; // in USD or PHP
        bool operational;
        uint256 timestamp;
        string ipfsHash;
        address proposer;
    }

    struct InfrastructureProject {
        uint256 id;
        string projectType; // "AI Data Center", "Manufacturing Plant", "Power Plant"
        string name;
        string location;
        uint256 estimatedCost;
        bool feasible; // true = feasible, false = skeptical
        string notes;
        uint256 timestamp;
        string ipfsHash;
        address proposer;
    }

    struct EnergyPolicy {
        uint256 id;
        string policyName; // "EPIRA Reform", "Modular Nuclear"
        string description;
        bool implemented;
        bool viable;
        string notes;
        uint256 timestamp;
        string ipfsHash;
        address proposer;
    }

    struct GovernanceFailure {
        uint256 id;
        string category; // "Flood Control", "Fiscal Policy", "Work Cancellations"
        string description;
        uint256 economicImpact; // estimated loss in USD/PHP
        bool resolved;
        string resolution;
        uint256 timestamp;
        string ipfsHash;
        address proposer;
    }

    struct ResilienceEvent {
        uint256 id;
        string eventType; // "Investor Confidence", "Fiscal Discipline", "Industrial Progress"
        string description;
        uint256 score; // 0-100
        uint256 timestamp;
        string ipfsHash;
        address proposer;
    }

    // ============================================================
    // STORAGE
    // ============================================================

    MineralProject[] public mineralProjects;
    InfrastructureProject[] public infrastructureProjects;
    EnergyPolicy[] public energyPolicies;
    GovernanceFailure[] public governanceFailures;
    ResilienceEvent[] public resilienceEvents;

    mapping(uint256 => mapping(address => bool)) public hasVotedMineral;
    mapping(uint256 => mapping(address => bool)) public hasVotedInfra;
    mapping(uint256 => mapping(address => bool)) public hasVotedPolicy;
    mapping(uint256 => mapping(address => bool)) public hasVotedFailure;

    // ============================================================
    // EVENTS
    // ============================================================

    event MineralProjectLogged(uint256 indexed id, string mineral, string projectName);
    event InfrastructureProjectLogged(uint256 indexed id, string projectType, bool feasible);
    event EnergyPolicyLogged(uint256 indexed id, string policyName, bool viable);
    event GovernanceFailureLogged(uint256 indexed id, string category, uint256 economicImpact);
    event ResilienceEventLogged(uint256 indexed id, string eventType, uint256 score);
    event Voted(uint256 indexed id, address voter);

    // ============================================================
    // MODIFIERS
    // ============================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    // ============================================================
    // CONSTRUCTOR
    // ============================================================

    constructor() {
        admin = msg.sender;
        active = true;
    }

    // ============================================================
    // 1. MINERAL PROJECTS — Value-Add Industrialization
    // ============================================================

    function logMineralProject(
        string memory _mineral,
        string memory _projectName,
        string memory _location,
        uint256 _valueAdd,
        uint256 _investmentAmount,
        string memory _ipfsHash
    ) public onlyAdmin whenActive {
        require(bytes(_mineral).length > 0, "Mineral required");
        require(_valueAdd <= 100, "Value-add must be <= 100%");

        uint256 id = mineralProjects.length;
        mineralProjects.push(MineralProject({
            id: id,
            mineral: _mineral,
            projectName: _projectName,
            location: _location,
            valueAdd: _valueAdd,
            investmentAmount: _investmentAmount,
            operational: false,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash,
            proposer: msg.sender
        }));

        emit MineralProjectLogged(id, _mineral, _projectName);
    }

    function markMineralOperational(uint256 _id) public onlyAdmin whenActive {
        require(_id < mineralProjects.length, "Invalid project");
        mineralProjects[_id].operational = true;
    }

    function getMineralProject(uint256 _id) public view returns (MineralProject memory) {
        require(_id < mineralProjects.length, "Invalid project");
        return mineralProjects[_id];
    }

    function getMineralProjects() public view returns (MineralProject[] memory) {
        return mineralProjects;
    }

    // ============================================================
    // 2. INFRASTRUCTURE PROJECTS — AI, Manufacturing, Power
    // ============================================================

    function logInfrastructureProject(
        string memory _projectType,
        string memory _name,
        string memory _location,
        uint256 _estimatedCost,
        bool _feasible,
        string memory _notes,
        string memory _ipfsHash
    ) public onlyAdmin whenActive {
        uint256 id = infrastructureProjects.length;
        infrastructureProjects.push(InfrastructureProject({
            id: id,
            projectType: _projectType,
            name: _name,
            location: _location,
            estimatedCost: _estimatedCost,
            feasible: _feasible,
            notes: _notes,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash,
            proposer: msg.sender
        }));

        emit InfrastructureProjectLogged(id, _projectType, _feasible);
    }

    function getInfrastructureProject(uint256 _id) public view returns (InfrastructureProject memory) {
        require(_id < infrastructureProjects.length, "Invalid project");
        return infrastructureProjects[_id];
    }

    function getInfrastructureProjects() public view returns (InfrastructureProject[] memory) {
        return infrastructureProjects;
    }

    // ============================================================
    // 3. ENERGY POLICY — EPIRA, Modular Nuclear, etc.
    // ============================================================

    function logEnergyPolicy(
        string memory _policyName,
        string memory _description,
        bool _viable,
        string memory _notes,
        string memory _ipfsHash
    ) public onlyAdmin whenActive {
        uint256 id = energyPolicies.length;
        energyPolicies.push(EnergyPolicy({
            id: id,
            policyName: _policyName,
            description: _description,
            implemented: false,
            viable: _viable,
            notes: _notes,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash,
            proposer: msg.sender
        }));

        emit EnergyPolicyLogged(id, _policyName, _viable);
    }

    function markPolicyImplemented(uint256 _id) public onlyAdmin whenActive {
        require(_id < energyPolicies.length, "Invalid policy");
        energyPolicies[_id].implemented = true;
    }

    function getEnergyPolicy(uint256 _id) public view returns (EnergyPolicy memory) {
        require(_id < energyPolicies.length, "Invalid policy");
        return energyPolicies[_id];
    }

    function getEnergyPolicies() public view returns (EnergyPolicy[] memory) {
        return energyPolicies;
    }

    // ============================================================
    // 4. GOVERNANCE FAILURES — Flood Control, Fiscal, etc.
    // ============================================================

    function logGovernanceFailure(
        string memory _category,
        string memory _description,
        uint256 _economicImpact,
        string memory _ipfsHash
    ) public onlyAdmin whenActive {
        uint256 id = governanceFailures.length;
        governanceFailures.push(GovernanceFailure({
            id: id,
            category: _category,
            description: _description,
            economicImpact: _economicImpact,
            resolved: false,
            resolution: "",
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash,
            proposer: msg.sender
        }));

        emit GovernanceFailureLogged(id, _category, _economicImpact);
    }

    function resolveGovernanceFailure(uint256 _id, string memory _resolution) public onlyAdmin whenActive {
        require(_id < governanceFailures.length, "Invalid failure");
        governanceFailures[_id].resolved = true;
        governanceFailures[_id].resolution = _resolution;
    }

    function getGovernanceFailure(uint256 _id) public view returns (GovernanceFailure memory) {
        require(_id < governanceFailures.length, "Invalid failure");
        return governanceFailures[_id];
    }

    function getGovernanceFailures() public view returns (GovernanceFailure[] memory) {
        return governanceFailures;
    }

    // ============================================================
    // 5. RESILIENCE EVENTS — Investor Confidence, Fiscal Discipline
    // ============================================================

    function logResilienceEvent(
        string memory _eventType,
        string memory _description,
        uint256 _score,
        string memory _ipfsHash
    ) public onlyAdmin whenActive {
        require(_score <= 100, "Score must be <= 100");

        uint256 id = resilienceEvents.length;
        resilienceEvents.push(ResilienceEvent({
            id: id,
            eventType: _eventType,
            description: _description,
            score: _score,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash,
            proposer: msg.sender
        }));

        emit ResilienceEventLogged(id, _eventType, _score);
    }

    function getResilienceEvent(uint256 _id) public view returns (ResilienceEvent memory) {
        require(_id < resilienceEvents.length, "Invalid event");
        return resilienceEvents[_id];
    }

    function getResilienceEvents() public view returns (ResilienceEvent[] memory) {
        return resilienceEvents;
    }

    // ============================================================
    // 6. COMMUNITY BENEFITS — Voting & Participation
    // ============================================================

    function voteMineralProject(uint256 _id) public whenActive {
        require(_id < mineralProjects.length, "Invalid project");
        require(!hasVotedMineral[_id][msg.sender], "Already voted");
        hasVotedMineral[_id][msg.sender] = true;
        emit Voted(_id, msg.sender);
    }

    function voteInfrastructureProject(uint256 _id) public whenActive {
        require(_id < infrastructureProjects.length, "Invalid project");
        require(!hasVotedInfra[_id][msg.sender], "Already voted");
        hasVotedInfra[_id][msg.sender] = true;
        emit Voted(_id, msg.sender);
    }

    function voteEnergyPolicy(uint256 _id) public whenActive {
        require(_id < energyPolicies.length, "Invalid policy");
        require(!hasVotedPolicy[_id][msg.sender], "Already voted");
        hasVotedPolicy[_id][msg.sender] = true;
        emit Voted(_id, msg.sender);
    }

    function voteGovernanceFailure(uint256 _id) public whenActive {
        require(_id < governanceFailures.length, "Invalid failure");
        require(!hasVotedFailure[_id][msg.sender], "Already voted");
        hasVotedFailure[_id][msg.sender] = true;
        emit Voted(_id, msg.sender);
    }

    // ============================================================
    // 7. ADMIN FUNCTIONS
    // ============================================================

    function toggleActive() public onlyAdmin {
        active = !active;
    }

    function transferAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid admin");
        admin = _newAdmin;
    }
}
