// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Hog Industry Policy Commitment Registry
/// @notice Transparency registry encoding the local hog raisers' policy
///         recommendations (October 2026 "Pork Holiday" demands) as
///         trackable, deadline-bound commitments.
/// @dev This contract is a transparency and accountability layer. It does
///      not execute customs, tariff, or monetary policy. Parameters encode
///      the federation's published recommendations:
///        - In-quota tariff restored to 30% (3000 bps)
///        - Out-quota tariff restored to 40% (4000 bps)
///        - Farmgate floor price of P210/kg (21000 centavos)
///        - Import pause of at least 60 days (federation asks 3-4 months)
contract HogIndustryPolicyRegistry {
    // ------------------------------------------------------------------
    // Types
    // ------------------------------------------------------------------

    /// @notice The nine concrete measures demanded by the federation.
    enum PolicyKind {
        TARIFF_RESTORATION, // EO raising in-quota 30% / out-quota 40%
        IMPORT_PAUSE, // SPSIC suspension for pork cuts
        COLD_STORAGE_FREEZE, // Halt release of imported frozen stock
        FLOOR_PRICE, // P210/kg farmgate floor
        RED_LANE_INSPECTION, // Jowls/offal to Customs red lane
        MDM_RESTRICTION, // MDM permits limited to accredited processors
        ASF_TESTING_PARITY, // Same shipping permits and testing as local
        TARIFF_RECLASSIFICATION, // Jowls taxed as pork meat, not offal
        SAFEGUARD_ACTIVATION // RA 8800 applied without phased schedule
    }

    /// @notice Lifecycle of every policy action.
    enum PolicyStatus {
        PROPOSED, // Federation has tabled the demand
        COMMITTED, // Admin (DA) has accepted it with a deadline
        ENFORCED, // Admin executed it with evidence
        VIOLATED, // Deadline passed without enforcement
        WITHDRAWN // Federation withdrew the demand
    }

    struct PolicyAction {
        uint256 id;
        PolicyKind kind;
        string description;
        uint256 primaryParam; // tariff bps / floor price centavos / pause days
        uint256 secondaryParam; // secondary parameter (e.g. out-quota bps)
        uint256 deadline;
        PolicyStatus status;
        bytes32 evidenceHash;
        address proposer;
        uint256 createdAt;
        uint256 committedAt;
        uint256 enforcedAt;
    }

    struct FarmgateReading {
        uint256 priceCentavosPerKg;
        uint256 recordedAt;
        address recorder;
    }

    /// @notice Recommended values from the federation's published demands.
    struct PolicyDefaults {
        uint256 inQuotaTariffBps; // 3000
        uint256 outQuotaTariffBps; // 4000
        uint256 floorPriceCentavos; // 21000
        uint256 minPauseDays; // 60
        uint256 federationPauseDays; // 120
    }

    // ------------------------------------------------------------------
    // Storage
    // ------------------------------------------------------------------

    address public admin;
    address public federationRep;

    PolicyDefaults public defaults;

    uint256 private _nextActionId = 1;

    mapping(uint256 => PolicyAction) private _actions;
    mapping(PolicyKind => uint256) public actionCountByKind;

    FarmgateReading[] private _farmgateReadings;

    // ------------------------------------------------------------------
    // Errors
    // ------------------------------------------------------------------

    error Unauthorized();
    error ActionNotFound();
    error InvalidDeadline();
    error InvalidPolicyKind();
    error InvalidStatus();
    error EnforceAfterDeadline();
    error InvalidEvidenceHash();
    error NoFloorPriceEnforced();
    error NoFarmgateReading();
    error ZeroParameter();

    // ------------------------------------------------------------------
    // Events
    // ------------------------------------------------------------------

    event ActionProposed(
        uint256 indexed id,
        PolicyKind indexed kind,
        string description,
        uint256 primaryParam,
        uint256 secondaryParam,
        uint256 deadline
    );
    event ActionCommitted(uint256 indexed id, uint256 deadline);
    event ActionEnforced(uint256 indexed id, bytes32 evidenceHash);
    event ActionViolated(uint256 indexed id, uint256 deadline);
    event ActionWithdrawn(uint256 indexed id);
    event FarmgatePriceRecorded(uint256 priceCentavosPerKg, uint256 recordedAt, address recorder);

    // ------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------

    constructor() {
        admin = msg.sender;
        federationRep = msg.sender;

        defaults = PolicyDefaults({
            inQuotaTariffBps: 3000,
            outQuotaTariffBps: 4000,
            floorPriceCentavos: 21000,
            minPauseDays: 60,
            federationPauseDays: 120
        });
    }

    // ------------------------------------------------------------------
    // Modifiers
    // ------------------------------------------------------------------

    modifier onlyAdmin() {
        if (msg.sender != admin) revert Unauthorized();
        _;
    }

    modifier onlyFederation() {
        if (msg.sender != federationRep) revert Unauthorized();
        _;
    }

    // ------------------------------------------------------------------
    // Federation actions
    // ------------------------------------------------------------------

    /// @notice The federation tables a policy demand with a deadline.
    function proposeAction(
        uint8 kind,
        string calldata description,
        uint256 primaryParam,
        uint256 secondaryParam,
        uint256 deadline
    ) external onlyFederation returns (uint256 id) {
        if (kind > uint8(PolicyKind.SAFEGUARD_ACTIVATION)) revert InvalidPolicyKind();
        if (deadline <= block.timestamp) revert InvalidDeadline();

        id = _nextActionId++;

        _actions[id] = PolicyAction({
            id: id,
            kind: PolicyKind(kind),
            description: description,
            primaryParam: primaryParam,
            secondaryParam: secondaryParam,
            deadline: deadline,
            status: PolicyStatus.PROPOSED,
            evidenceHash: bytes32(0),
            proposer: msg.sender,
            createdAt: block.timestamp,
            committedAt: 0,
            enforcedAt: 0
        });

        actionCountByKind[PolicyKind(kind)] += 1;

        emit ActionProposed(id, PolicyKind(kind), description, primaryParam, secondaryParam, deadline);
    }

    /// @notice The federation may withdraw a demand while still PROPOSED.
    function withdrawAction(uint256 id) external onlyFederation {
        PolicyAction storage action = _requireAction(id);
        if (action.status != PolicyStatus.PROPOSED) revert InvalidStatus();

        action.status = PolicyStatus.WITHDRAWN;

        emit ActionWithdrawn(id);
    }

    // ------------------------------------------------------------------
    // Admin (DA) actions
    // ------------------------------------------------------------------

    /// @notice The admin accepts a demand, binding itself to the deadline.
    function commitAction(uint256 id) external onlyAdmin {
        PolicyAction storage action = _requireAction(id);
        if (action.status != PolicyStatus.PROPOSED) revert InvalidStatus();
        if (action.deadline <= block.timestamp) revert InvalidDeadline();

        action.status = PolicyStatus.COMMITTED;
        action.committedAt = block.timestamp;

        emit ActionCommitted(id, action.deadline);
    }

    /// @notice The admin records enforcement with a public evidence hash.
    function enforceAction(uint256 id, bytes32 evidenceHash) external onlyAdmin {
        PolicyAction storage action = _requireAction(id);
        if (action.status != PolicyStatus.COMMITTED) revert InvalidStatus();
        if (evidenceHash == bytes32(0)) revert InvalidEvidenceHash();
        if (block.timestamp > action.deadline) revert EnforceAfterDeadline();

        action.status = PolicyStatus.ENFORCED;
        action.enforcedAt = block.timestamp;
        action.evidenceHash = evidenceHash;

        emit ActionEnforced(id, evidenceHash);
    }

    /// @notice Records a farmgate price reading for floor-price monitoring.
    function recordFarmgatePrice(uint256 priceCentavosPerKg) external onlyAdmin {
        if (priceCentavosPerKg == 0) revert ZeroParameter();

        _farmgateReadings.push(
            FarmgateReading({priceCentavosPerKg: priceCentavosPerKg, recordedAt: block.timestamp, recorder: msg.sender})
        );

        emit FarmgatePriceRecorded(priceCentavosPerKg, block.timestamp, msg.sender);
    }

    // ------------------------------------------------------------------
    // Public accountability
    // ------------------------------------------------------------------

    /// @notice Anyone can flag a COMMITTED action whose deadline lapsed.
    /// @dev This is the accountability hook: a missed DA deadline becomes
    ///      a permanently visible VIOLATED record.
    function markViolated(uint256 id) external {
        PolicyAction storage action = _requireAction(id);
        if (action.status != PolicyStatus.COMMITTED) revert InvalidStatus();
        if (block.timestamp <= action.deadline) revert InvalidDeadline();

        action.status = PolicyStatus.VIOLATED;

        emit ActionViolated(id, action.deadline);
    }

    // ------------------------------------------------------------------
    // Views
    // ------------------------------------------------------------------

    function getAction(uint256 id) external view returns (PolicyAction memory) {
        if (id == 0 || id >= _nextActionId) revert ActionNotFound();
        return _actions[id];
    }

    function totalActions() external view returns (uint256) {
        return _nextActionId - 1;
    }

    function totalFarmgateReadings() external view returns (uint256) {
        return _farmgateReadings.length;
    }

    function latestFarmgatePrice() external view returns (FarmgateReading memory) {
        if (_farmgateReadings.length == 0) revert NoFarmgateReading();
        return _farmgateReadings[_farmgateReadings.length - 1];
    }

    /// @notice Checks the latest reading against the most recent ENFORCED
    ///         floor-price action. Reverts if no floor price is enforced.
    function isBelowEnforcedFloor()
        external
        view
        returns (bool below, uint256 floorPriceCentavos, uint256 latestPriceCentavos)
    {
        if (_farmgateReadings.length == 0) revert NoFarmgateReading();

        uint256 enforcedFloor = 0;
        uint256 enforcedAtLatest = 0;
        bool found = false;

        for (uint256 id = 1; id < _nextActionId; id++) {
            PolicyAction storage action = _actions[id];
            if (
                action.kind == PolicyKind.FLOOR_PRICE && action.status == PolicyStatus.ENFORCED
                    && action.enforcedAt > enforcedAtLatest
            ) {
                enforcedFloor = action.primaryParam;
                enforcedAtLatest = action.enforcedAt;
                found = true;
            }
        }

        if (!found) revert NoFloorPriceEnforced();

        FarmgateReading memory latest = _farmgateReadings[_farmgateReadings.length - 1];
        return (latest.priceCentavosPerKg < enforcedFloor, enforcedFloor, latest.priceCentavosPerKg);
    }

    // ------------------------------------------------------------------
    // Internals
    // ------------------------------------------------------------------

    function _requireAction(uint256 id) private view returns (PolicyAction storage) {
        if (id == 0 || id >= _nextActionId) revert ActionNotFound();
        return _actions[id];
    }
}
