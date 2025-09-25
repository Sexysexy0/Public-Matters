// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ShadowBankingAuditProtocol
/// @notice Registry for synthetic instruments, swap opacity, and suppressed loss flags in shadow banking corridors
/// @dev Anchors breach-tiered transparency and emotional APR tagging for offshore audit trails

contract ShadowBankingAuditProtocol {
    // -------- Roles --------
    address public steward;
    mapping(address => bool) public auditors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender] || msg.sender == steward, "Not auditor");
        _;
    }

    // -------- Types --------
    enum BreachTier {
        None,
        Mild,
        Moderate,
        Severe,
        Catastrophic
    }

    struct Institution {
        string name;
        string jurisdiction;
        bool active;
        uint256 registeredAt;
    }

    struct Instrument {
        uint256 id;
        address institution;
        string instrumentType; // e.g., "Swap", "Repo", "Synthetic Loan"
        uint256 notionalUSD;
        BreachTier breachTier;
        string notes;
        bool flagged;
        uint256 createdAt;
        uint256 updatedAt;
    }

    // -------- Storage --------
    uint256 public nextInstrumentId = 1;
    mapping(address => Institution) public institutions;
    mapping(uint256 => Instrument) public instruments;
    mapping(address => uint256[]) public institutionInstruments;

    // -------- Events --------
    event AuditorSet(address indexed account, bool status);
    event InstitutionRegistered(address indexed account, string name, string jurisdiction);
    event InstrumentFiled(uint256 indexed id, address indexed institution, string instrumentType, uint256 notionalUSD);
    event LossSuppressionFlagged(uint256 indexed id, BreachTier tier, string notes);
    event InstrumentUpdated(uint256 indexed id, BreachTier tier, string notes);

    // -------- Constructor --------
    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    // -------- Auditor Management --------
    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    // -------- Institution Registry --------
    function registerInstitution(address account, string calldata name, string calldata jurisdiction) external onlyAuditor {
        Institution storage inst = institutions[account];
        require(!inst.active, "Already registered");
        inst.name = name;
        inst.jurisdiction = jurisdiction;
        inst.active = true;
        inst.registeredAt = block.timestamp;
        emit InstitutionRegistered(account, name, jurisdiction);
    }

    // -------- Instrument Filing --------
    function fileInstrument(
        address institution,
        string calldata instrumentType,
        uint256 notionalUSD,
        string calldata notes
    ) external onlyAuditor returns (uint256 id) {
        require(institutions[institution].active, "Institution not registered");
        id = nextInstrumentId++;
        instruments[id] = Instrument({
            id: id,
            institution: institution,
            instrumentType: instrumentType,
            notionalUSD: notionalUSD,
            breachTier: BreachTier.None,
            notes: notes,
            flagged: false,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        institutionInstruments[institution].push(id);
        emit InstrumentFiled(id, institution, instrumentType, notionalUSD);
    }

    // -------- Breach Tagging --------
    function flagLossSuppression(uint256 id, BreachTier tier, string calldata notes) external onlyAuditor {
        Instrument storage inst = instruments[id];
        require(inst.id != 0, "Instrument not found");
        inst.breachTier = tier;
        inst.notes = notes;
        inst.flagged = true;
        inst.updatedAt = block.timestamp;
        emit LossSuppressionFlagged(id, tier, notes);
    }

    function updateInstrument(uint256 id, BreachTier tier, string calldata notes) external onlyAuditor {
        Instrument storage inst = instruments[id];
        require(inst.id != 0, "Instrument not found");
        inst.breachTier = tier;
        inst.notes = notes;
        inst.updatedAt = block.timestamp;
        emit InstrumentUpdated(id, tier, notes);
    }

    // -------- Views --------
    function getInstitution(address account) external view returns (Institution memory) {
        return institutions[account];
    }

    function getInstrument(uint256 id) external view returns (Instrument memory) {
        return instruments[id];
    }

    function listInstitutionInstruments(address account) external view returns (uint256[] memory) {
        return institutionInstruments[account];
    }
}
