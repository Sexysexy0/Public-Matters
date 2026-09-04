// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

/**
 * @title CandabaEcologicalGuardian
 * @author The Source
 * @notice Enforces environmental protections for the Candaba Swamp.
 * @dev Requires impact assessments before any excavation or construction.
 */
contract CandabaEcologicalGuardian {
    address public admin;
    address public sovereignOracle;
    bool public active;
    uint256 public assessmentCount;

    struct EnvironmentalAssessment {
        uint256 id;
        string projectName;
        string description;
        uint256 areaImpacted; // In hectares
        string ecologist; // Name of assessing ecologist
        string findings;
        bool approved;
        bool executed;
        uint256 timestamp;
        string ipfsHash; // Link to full assessment
    }

    struct ProtectedZone {
        uint256 id;
        string name;
        string location;
        uint256 areaHectares;
        bool active;
        uint256 timestamp;
        string ipfsHash;
    }

    mapping(uint256 => EnvironmentalAssessment) public assessments;
    mapping(uint256 => ProtectedZone) public protectedZones;
    mapping(address => bool) public isEcologist;
    uint256 public zoneCount;

    event AssessmentSubmitted(uint256 indexed id, string projectName);
    event AssessmentApproved(uint256 indexed id, bool approved);
    event ProtectedZoneCreated(uint256 indexed id, string name);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyEcologist() {
        require(isEcologist[msg.sender], "Not an ecologist");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    constructor(address _sovereignOracle) {
        admin = msg.sender;
        sovereignOracle = _sovereignOracle;
        active = true;
        assessmentCount = 0;
        zoneCount = 0;
        isEcologist[msg.sender] = true;
    }

    function addEcologist(address _ecologist) public onlyAdmin whenActive {
        isEcologist[_ecologist] = true;
    }

    function removeEcologist(address _ecologist) public onlyAdmin whenActive {
        isEcologist[_ecologist] = false;
    }

    function createProtectedZone(
        string memory _name,
        string memory _location,
        uint256 _areaHectares,
        string memory _ipfsHash
    ) public onlyAdmin whenActive {
        uint256 zoneId = zoneCount;
        protectedZones[zoneId] = ProtectedZone({
            id: zoneId,
            name: _name,
            location: _location,
            areaHectares: _areaHectares,
            active: true,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash
        });
        zoneCount++;
        emit ProtectedZoneCreated(zoneId, _name);
    }

    function submitAssessment(
        string memory _projectName,
        string memory _description,
        uint256 _areaImpacted,
        string memory _ecologist,
        string memory _ipfsHash
    ) public onlyEcologist whenActive {
        require(_areaImpacted > 0, "Area must be > 0");

        uint256 assessmentId = assessmentCount;
        assessments[assessmentId] = EnvironmentalAssessment({
            id: assessmentId,
            projectName: _projectName,
            description: _description,
            areaImpacted: _areaImpacted,
            ecologist: _ecologist,
            findings: "",
            approved: false,
            executed: false,
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash
        });
        assessmentCount++;
        emit AssessmentSubmitted(assessmentId, _projectName);
    }

    function approveAssessment(uint256 _assessmentId, bool _approved, string memory _findings)
        public
        onlyAdmin
        whenActive
    {
        require(_assessmentId < assessmentCount, "Invalid assessment");
        require(!assessments[_assessmentId].executed, "Already executed");

        EnvironmentalAssessment storage a = assessments[_assessmentId];
        a.approved = _approved;
        a.findings = _findings;
        a.executed = true;

        emit AssessmentApproved(_assessmentId, _approved);
    }

    function getAssessment(uint256 _assessmentId) public view returns (EnvironmentalAssessment memory) {
        require(_assessmentId < assessmentCount, "Invalid assessment");
        return assessments[_assessmentId];
    }

    function getProtectedZone(uint256 _zoneId) public view returns (ProtectedZone memory) {
        require(_zoneId < zoneCount, "Invalid zone");
        return protectedZones[_zoneId];
    }

    function getZoneCount() public view returns (uint256) {
        return zoneCount;
    }

    function getAssessmentCount() public view returns (uint256) {
        return assessmentCount;
    }

    function toggleActive() public onlyAdmin {
        active = !active;
    }
}
