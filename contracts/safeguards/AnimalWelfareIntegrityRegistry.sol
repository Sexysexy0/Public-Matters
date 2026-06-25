// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AnimalWelfareIntegrityRegistry
 * @notice Engineering solution providing decentralization infrastructure to fight animal cruelty through immutable logs and tamper-proof case tracking.
 */
contract AnimalWelfareIntegrityRegistry {
    event AnimalPassportCreated(bytes32 indexed animalId, string species, address indexed initialHandler);
    event WelfareStatusUpdated(bytes32 indexed animalId, HealthCondition condition, address indexed updaterNode);
    event CrueltyIncidentLogged(bytes32 indexed incidentId, bytes32 encryptedEvidenceHash, uint256 emergencyTier);
    event EnforcerNodeAuthorized(address indexed enforcementAgency, bool status);

    address public registrySteward;
    uint256 public totalRegisteredAnimals;
    uint256 public totalActiveCrueltyCases;

    enum HealthCondition { Optimal, UnderTreatment, Critical, Rehabilitated }

    struct AnimalProfile {
        string species;
        uint256 registrationBlock;
        HealthCondition currentCondition;
        address activeHandler;
        bool initialized;
    }

    struct CrueltyIncident {
        bytes32 evidenceHash; // Keccak-256 encrypted storage link to decentralize media evidence (e.g., IPFS)
        uint256 incidentBlock;
        uint256 urgencyTier; // 1 = Neglect, 3 = Active Abuse, 5 = Severe Emergency
        bool investigationClosed;
        bool initialized;
    }

    // Master registry tracking registered animal passports
    mapping(bytes32 => AnimalProfile) public animalPassportGrid;
    // Transparent ledger tracking active abuse and cruelty reports
    mapping(bytes32 => CrueltyIncident) public crueltyIncidentLedger;
    // Authorized shelter organizations, vets, and welfare officers (e.g., DLSU Pusa node)
    mapping(address => bool) public authorizedWelfareEnforcers;

    constructor() {
        registrySteward = msg.sender;
        authorizedWelfareEnforcers[msg.sender] = true;
    }

    modifier onlySteward() {
        require(msg.sender == registrySteward, "Access Denied: Master steward verification signature failure");
        _;
    }

    modifier onlyAuthorizedEnforcer() {
        require(authorizedWelfareEnforcers[msg.sender], "Access Denied: Caller node is not a verified welfare enforcer");
        _;
    }

    /**
     * @notice Registers a trusted animal welfare organization or veterinary node allowed to update health telemetry.
     */
    function configureEnforcerNode(address _enforcer, bool _status) external onlySteward {
        require(_enforcer != address(0), "Parameter Error: Enforcer node address cannot be blank coordinate");
        authorizedWelfareEnforcers[_enforcer] = _status;
        emit EnforcerNodeAuthorized(_enforcer, _status);
    }

    /**
     * @notice Immutably boards a rescued animal into the global safety registry.
     * @param _animalId Cryptographic hash derived from the animal's microchip, unique marks, or rescue coordinate.
     */
    function instantiateAnimalPassport(
        bytes32 _animalId, 
        string calldata _species, 
        HealthCondition _initialCondition
    ) external onlyAuthorizedEnforcer {
        require(_animalId != bytes32(0), "Parameter Error: Animal ID token cannot be empty");
        require(!animalPassportGrid[_animalId].initialized, "Collision Intercept: Animal passport already exists");

        animalPassportGrid[_animalId] = AnimalProfile({
            species: _species,
            registrationBlock: block.number,
            currentCondition: _initialCondition,
            activeHandler: msg.sender,
            initialized: true
        });

        totalRegisteredAnimals += 1;
        emit AnimalPassportCreated(_animalId, _species, msg.sender);
    }

    /**
     * @notice Updates the live welfare status of an animal. Prevents historical manipulation of health records.
     */
    function updateAnimalWelfareStatus(bytes32 _animalId, HealthCondition _newCondition) external onlyAuthorizedEnforcer {
        AnimalProfile storage profile = animalPassportGrid[_animalId];
        require(profile.initialized, "Registry Exception: Specified animal profile does not exist");
        
        profile.currentCondition = _newCondition;
        profile.activeHandler = msg.sender;

        emit WelfareStatusUpdated(_animalId, _newCondition, msg.sender);
    }

    /**
     * @notice Public, high-security anonymous portal to log active animal cruelty incidents.
     * @param _incidentId Cryptographic unique hash identifier for the specific event tracker.
     * @param _evidenceHash The decentralize storage fingerprint containing immutable photo/video logs.
     * @param _urgency Tier scaling from 1 (minor) to 5 (critical physical threat).
     */
    function logCrueltyIncident(
        bytes32 _incidentId, 
        bytes32 _evidenceHash, 
        uint256 _urgency
    ) external {
        require(_incidentId != bytes32(0) && _evidenceHash != bytes32(0), "Parameter Error: Invalid tracking signatures");
        require(!crueltyIncidentLedger[_incidentId].initialized, "Collision Intercept: Case reference already registered");
        require(_urgency >= 1 && _urgency <= 5, "Parameter Error: Urgency validation score falls outside operational matrix");

        crueltyIncidentLedger[_incidentId] = CrueltyIncident({
            evidenceHash: _evidenceHash,
            incidentBlock: block.number,
            urgencyTier: _urgency,
            investigationClosed: false,
            initialized: true
        });

        totalActiveCrueltyCases += 1;
        emit CrueltyIncidentLogged(_incidentId, _evidenceHash, _urgency);
    }

    /**
     * @notice Resolves or closes an active cruelty investigation once rescue and intervention operations succeed.
     */
    function closeCrueltyCase(bytes32 _incidentId) external onlyAuthorizedEnforcer {
        CrueltyIncident storage scenario = crueltyIncidentLedger[_incidentId];
        require(scenario.initialized, "Registry Exception: Target incident trace is uninstantiated");
        require(!scenario.investigationClosed, "State Error: Targeted case file is already marked resolved");

        scenario.investigationClosed = true;
        totalActiveCrueltyCases -= 1;
    }
}
