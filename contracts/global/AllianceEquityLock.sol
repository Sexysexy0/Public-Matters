// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AllianceEquityLock
 * @notice Treaty-grade lock for bilateral alliances:
 *         - Mutual-consent amendments (two-party multisig)
 *         - Clause registry (zero-tariff, mobility, infrastructure, etc.)
 *         - Breach logging + cure workflow
 *         - Heartbeat liveness checks per party
 *         - Optional arbiter-assisted dispute resolution
 *
 * Parties: partyA (e.g., Alberta), partyB (e.g., United States, or designated federal/state entity)
 */
contract AllianceEquityLock {
    // ------------------------------------------------------------
    // Roles
    // ------------------------------------------------------------
    address public immutable partyA;
    address public immutable partyB;
    address public arbiter; // optional neutral third party

    modifier onlyParty() {
        require(msg.sender == partyA || msg.sender == partyB, "Not a treaty party");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Not arbiter");
        _;
    }

    // ------------------------------------------------------------
    // Core structures
    // ------------------------------------------------------------
    enum ClauseState { Inactive, Active, Suspended }

    struct Clause {
        string title;          // e.g., "Zero Tariffs on Allied Goods"
        string descriptor;     // human-readable details or URI to MD
        ClauseState state;     // Active/Inactive/Suspended
        uint256 createdAt;
        uint256 lastUpdatedAt;
    }

    struct Breach {
        uint256 clauseId;
        address reporter;      // party that reported breach
        string reason;         // narrative (e.g., "Tariff imposed on energy exports")
        uint256 reportedAt;
        bool cured;            // marked after cure
        uint256 curedAt;
        string cureNote;       // how it was resolved/cured
        bool arbitrated;       // whether arbiter intervened
        string arbiterFinding; // summary of determination
    }

    // Clauses and breaches
    Clause[] public clauses;
    Breach[] public breaches;

    // Amendment proposals
    struct Amendment {
        uint256 clauseId;
        string newTitle;
        string newDescriptor;
        ClauseState newState;
        bool approvedByA;
        bool approvedByB;
        uint256 proposedAt;
        bool executed;
    }

    Amendment[] public amendments;

    // Party heartbeats (keep-alive pings)
    mapping(address => uint256) public lastHeartbeat; // last ping timestamp
    uint256 public heartbeatGrace; // seconds allowed between pings (e.g., 30 days)

    // Global metadata
    string public treatyName;        // e.g., "Alberta–U.S. Alliance"
    string public publicManifestURI; // e.g., IPFS/Git link to blessing deck/covenant

    // Events
    event TreatyInitialized(string treatyName, string manifestURI, address partyA, address partyB);
    event ArbiterUpdated(address arbiter);
    event ClauseAdded(uint256 indexed clauseId, string title, ClauseState state);
    event ClauseStateChanged(uint256 indexed clauseId, ClauseState newState);
    event AmendmentProposed(uint256 indexed amendmentId, uint256 indexed clauseId);
    event AmendmentApproved(uint256 indexed amendmentId, address party);
    event AmendmentExecuted(uint256 indexed amendmentId);
    event BreachReported(uint256 indexed breachId, uint256 indexed clauseId, address reporter, string reason);
    event BreachCured(uint256 indexed breachId, string note);
    event BreachArbitrated(uint256 indexed breachId, string finding);
    event Heartbeat(address indexed party, uint256 timestamp);
    event HeartbeatGraceUpdated(uint256 graceSeconds);

    // ------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------
    constructor(
        address _partyA,
        address _partyB,
        string memory _treatyName,
        string memory _publicManifestURI,
        uint256 _heartbeatGraceSeconds,
        address _arbiter
    ) {
        require(_partyA != address(0) && _partyB != address(0), "Invalid parties");
        partyA = _partyA;
        partyB = _partyB;
        treatyName = _treatyName;
        publicManifestURI = _publicManifestURI;
        heartbeatGrace = _heartbeatGraceSeconds;
        arbiter = _arbiter;

        // Initialize heartbeats at deploy time
        uint256 nowTs = block.timestamp;
        lastHeartbeat[partyA] = nowTs;
        lastHeartbeat[partyB] = nowTs;

        emit TreatyInitialized(_treatyName, _publicManifestURI, _partyA, _partyB);
        if (_arbiter != address(0)) emit ArbiterUpdated(_arbiter);
        emit HeartbeatGraceUpdated(_heartbeatGraceSeconds);
    }

    // ------------------------------------------------------------
    // Admin/meta (mutual trust signals)
    // ------------------------------------------------------------
    function updateManifestURI(string memory _uri) external onlyParty {
        publicManifestURI = _uri;
        // Intentionally no event spam beyond initialization to keep gas low; 
        // off-chain indexers can watch storage changes if needed.
    }

    function setArbiter(address _arbiter) external onlyParty {
        arbiter = _arbiter;
        emit ArbiterUpdated(_arbiter);
    }

    function setHeartbeatGrace(uint256 _seconds) external onlyParty {
        heartbeatGrace = _seconds;
        emit HeartbeatGraceUpdated(_seconds);
    }

    // ------------------------------------------------------------
    // Heartbeats (liveness)
    // ------------------------------------------------------------
    function ping() external onlyParty {
        lastHeartbeat[msg.sender] = block.timestamp;
        emit Heartbeat(msg.sender, block.timestamp);
    }

    function isPartyResponsive(address party) public view returns (bool) {
        uint256 last = lastHeartbeat[party];
        if (last == 0) return false;
        return block.timestamp <= last + heartbeatGrace;
    }

    function bothResponsive() external view returns (bool) {
        return isPartyResponsive(partyA) && isPartyResponsive(partyB);
    }

    // ------------------------------------------------------------
    // Clause management (mutual stability canon)
    // ------------------------------------------------------------
    function addClause(
        string memory title,
        string memory descriptor,
        ClauseState state
    ) external onlyParty returns (uint256 clauseId) {
        clauses.push(Clause({
            title: title,
            descriptor: descriptor,
            state: state,
            createdAt: block.timestamp,
            lastUpdatedAt: block.timestamp
        }));
        clauseId = clauses.length - 1;
        emit ClauseAdded(clauseId, title, state);
    }

    // Amendment flow: propose -> approve (A & B) -> execute
    function proposeAmendment(
        uint256 clauseId,
        string memory newTitle,
        string memory newDescriptor,
        ClauseState newState
    ) external onlyParty returns (uint256 amendmentId) {
        require(clauseId < clauses.length, "Invalid clause");
        amendments.push(Amendment({
            clauseId: clauseId,
            newTitle: newTitle,
            newDescriptor: newDescriptor,
            newState: newState,
            approvedByA: false,
            approvedByB: false,
            proposedAt: block.timestamp,
            executed: false
        }));
        amendmentId = amendments.length - 1;
        emit AmendmentProposed(amendmentId, clauseId);
    }

    function approveAmendment(uint256 amendmentId) external onlyParty {
        require(amendmentId < amendments.length, "Invalid amendment");
        Amendment storage a = amendments[amendmentId];
        require(!a.executed, "Already executed");

        if (msg.sender == partyA) a.approvedByA = true;
        if (msg.sender == partyB) a.approvedByB = true;

        emit AmendmentApproved(amendmentId, msg.sender);
    }

    function executeAmendment(uint256 amendmentId) external onlyParty {
        require(amendmentId < amendments.length, "Invalid amendment");
        Amendment storage a = amendments[amendmentId];
        require(!a.executed, "Already executed");
        require(a.approvedByA && a.approvedByB, "Both parties must approve");

        Clause storage c = clauses[a.clauseId];
        c.title = a.newTitle;
        c.descriptor = a.newDescriptor;
        c.state = a.newState;
        c.lastUpdatedAt = block.timestamp;

        a.executed = true;

        emit AmendmentExecuted(amendmentId);
        emit ClauseStateChanged(a.clauseId, a.newState);
    }

    // ------------------------------------------------------------
    // Breach reporting and cure workflow
    // ------------------------------------------------------------
    function reportBreach(
        uint256 clauseId,
        string memory reason
    ) external onlyParty returns (uint256 breachId) {
        require(clauseId < clauses.length, "Invalid clause");
        breaches.push(Breach({
            clauseId: clauseId,
            reporter: msg.sender,
            reason: reason,
            reportedAt: block.timestamp,
            cured: false,
            curedAt: 0,
            cureNote: "",
            arbitrated: false,
            arbiterFinding: ""
        }));
        breachId = breaches.length - 1;
        emit BreachReported(breachId, clauseId, msg.sender, reason);
    }

    function markCured(
        uint256 breachId,
        string memory note
    ) external onlyParty {
        require(breachId < breaches.length, "Invalid breach");
        Breach storage b = breaches[breachId];
        require(!b.cured, "Already cured");
        b.cured = true;
        b.curedAt = block.timestamp;
        b.cureNote = note;
        emit BreachCured(breachId, note);
    }

    function arbitrateBreach(
        uint256 breachId,
        string memory finding
    ) external onlyArbiter {
        require(breachId < breaches.length, "Invalid breach");
        Breach storage b = breaches[breachId];
        b.arbitrated = true;
        b.arbiterFinding = finding;
        emit BreachArbitrated(breachId, finding);
    }

    // ------------------------------------------------------------
    // Views (for dashboards)
    // ------------------------------------------------------------
    function totalClauses() external view returns (uint256) { return clauses.length; }
    function totalAmendments() external view returns (uint256) { return amendments.length; }
    function totalBreaches() external view returns (uint256) { return breaches.length; }

    // Convenience: quick check for canonical zero-tariff clause active
    function isZeroTariffActive(uint256 clauseId) external view returns (bool) {
        require(clauseId < clauses.length, "Invalid clause");
        Clause storage c = clauses[clauseId];
        // Convention: title contains "Zero Tariff" or descriptor references it
        bool labeled = _contains(c.title, "Zero Tariff") || _contains(c.descriptor, "Zero Tariff");
        return labeled && c.state == ClauseState.Active;
    }

    // Minimal substring check (case-sensitive)
    function _contains(string memory a, string memory b) internal pure returns (bool) {
        bytes memory aa = bytes(a);
        bytes memory bb = bytes(b);
        if (bb.length == 0 || bb.length > aa.length) return false;
        for (uint256 i = 0; i <= aa.length - bb.length; i++) {
            bool match_ = true;
            for (uint256 j = 0; j < bb.length; j++) {
                if (aa[i + j] != bb[j]) { match_ = false; break; }
            }
            if (match_) return true;
        }
        return false;
    }
}
