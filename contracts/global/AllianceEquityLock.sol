// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AllianceEquityLock (Multi-Nation)
 * @notice Treaty-grade stability lock for multi-country alliances:
 *  - N-of-M supermajority governance (amend, admit, withdraw)
 *  - Clause registry (Zero Tariff, Non-Tariff Barriers, Mobility, Security, etc.)
 *  - Breach reporting, cure workflow, optional arbiter ruling
 *  - Heartbeat liveness per member; alliance health checks
 *  - Accession (join) and Withdrawal (graceful exit) with supermajority
 *  - Public manifest link (Deck/Covenant) for transparency
 */
contract AllianceEquityLock {
    // ---------------- Members & Governance ----------------
    struct Member {
        bool active;
        uint256 joinedAt;
        string name;      // e.g., "United States"
        string role;      // e.g., "Founding", "Signatory"
    }

    address public immutable deployer;
    address public arbiter; // optional neutral third party (can be council multisig)

    mapping(address => Member) public members;
    address[] public memberList;

    // governance threshold: approvals required among active members
    uint256 public approvalsRequired; // e.g., supermajority (ceil(2/3 * active))
    uint256 public heartbeatGrace;    // seconds between required pings, e.g., 30 days

    // ---------------- Clauses & Amendments ----------------
    enum ClauseState { Inactive, Active, Suspended }

    struct Clause {
        string title;          // e.g., "Zero Tariff"
        string descriptorURI;  // URI to markdown spec (Deck section)
        ClauseState state;
        uint256 createdAt;
        uint256 lastUpdatedAt;
    }

    Clause[] public clauses;

    struct Amendment {
        uint256 clauseId;
        string newTitle;
        string newDescriptorURI;
        ClauseState newState;
        uint256 proposedAt;
        bool executed;
        mapping(address => bool) approvals; // member approvals
        uint256 approvalsCount;
    }

    Amendment[] public amendments;

    // ---------------- Breach & Cure ----------------
    struct Breach {
        uint256 clauseId;
        address reporter;      // member who reports
        string reason;         // narrative
        uint256 reportedAt;
        bool cured;
        uint256 curedAt;
        string cureNote;
        bool arbitrated;
        string arbiterFinding;
    }

    Breach[] public breaches;

    // ---------------- Heartbeats ----------------
    mapping(address => uint256) public lastHeartbeat;

    // ---------------- Public Meta ----------------
    string public treatyName;         // e.g., "Global Good Deals Treaty"
    string public publicManifestURI;  // URI to GlobalGoodDealsTreatyDeck.md

    // ---------------- Events ----------------
    event TreatyInitialized(string treatyName, string manifestURI, uint256 members, uint256 approvalsRequired);
    event ArbiterUpdated(address arbiter);
    event HeartbeatGraceUpdated(uint256 graceSeconds);
    event MemberJoined(address indexed account, string name, string role);
    event MemberWithdrawn(address indexed account, string reason);
    event GovernanceThresholdUpdated(uint256 newApprovalsRequired);

    event Heartbeat(address indexed member, uint256 timestamp);

    event ClauseAdded(uint256 indexed clauseId, string title, ClauseState state);
    event AmendmentProposed(uint256 indexed amendmentId, uint256 clauseId);
    event AmendmentApproved(uint256 indexed amendmentId, address member, uint256 approvalsCount);
    event AmendmentExecuted(uint256 indexed amendmentId);
    event ClauseStateChanged(uint256 indexed clauseId, ClauseState newState);

    event BreachReported(uint256 indexed breachId, uint256 indexed clauseId, address reporter, string reason);
    event BreachCured(uint256 indexed breachId, string note);
    event BreachArbitrated(uint256 indexed breachId, string finding);

    // ---------------- Modifiers ----------------
    modifier onlyMember() {
        require(members[msg.sender].active, "Not a member");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Not arbiter");
        _;
    }

    // ---------------- Constructor ----------------
    constructor(
        string memory _treatyName,
        string memory _manifestURI,
        address[] memory initialMembers,
        string[] memory names,
        string[] memory roles,
        uint256 _approvalsRequired,
        uint256 _heartbeatGraceSeconds,
        address _arbiter
    ) {
        require(initialMembers.length > 0, "No members");
        require(
            initialMembers.length == names.length && names.length == roles.length,
            "Array length mismatch"
        );
        deployer = msg.sender;
        treatyName = _treatyName;
        publicManifestURI = _manifestURI;
        heartbeatGrace = _heartbeatGraceSeconds;
        arbiter = _arbiter;

        for (uint256 i = 0; i < initialMembers.length; i++) {
            address m = initialMembers[i];
            require(m != address(0), "Invalid member");
            members[m] = Member({active: true, joinedAt: block.timestamp, name: names[i], role: roles[i]});
            memberList.push(m);
            lastHeartbeat[m] = block.timestamp;
            emit MemberJoined(m, names[i], roles[i]);
        }

        approvalsRequired = _approvalsRequired == 0 ? _defaultSupermajority() : _approvalsRequired;

        emit ArbiterUpdated(_arbiter);
        emit HeartbeatGraceUpdated(_heartbeatGraceSeconds);
        emit TreatyInitialized(_treatyName, _manifestURI, memberList.length, approvalsRequired);
    }

    // ---------------- Admin / Meta ----------------
    function updateManifestURI(string memory _uri) external onlyMember {
        publicManifestURI = _uri;
    }

    function setArbiter(address _arbiter) external onlyMember {
        arbiter = _arbiter;
        emit ArbiterUpdated(_arbiter);
    }

    function setHeartbeatGrace(uint256 _seconds) external onlyMember {
        heartbeatGrace = _seconds;
        emit HeartbeatGraceUpdated(_seconds);
    }

    function setApprovalsRequired(uint256 _count) external onlyMember {
        require(_count > 0 && _count <= activeMembersCount(), "Invalid threshold");
        approvalsRequired = _count;
        emit GovernanceThresholdUpdated(_count);
    }

    // ---------------- Heartbeats ----------------
    function ping() external onlyMember {
        lastHeartbeat[msg.sender] = block.timestamp;
        emit Heartbeat(msg.sender, block.timestamp);
    }

    function isResponsive(address m) public view returns (bool) {
        if (!members[m].active) return false;
        uint256 last = lastHeartbeat[m];
        return last != 0 && block.timestamp <= last + heartbeatGrace;
    }

    function allianceHealthy(uint256 minResponsive) external view returns (bool) {
        uint256 responsive = 0;
        for (uint256 i = 0; i < memberList.length; i++) {
            if (isResponsive(memberList[i])) responsive++;
        }
        return responsive >= minResponsive;
    }

    // ---------------- Membership (Join/Withdraw) ----------------
    struct JoinProposal {
        address account;
        string name;
        string role;
        uint256 proposedAt;
        bool executed;
        mapping(address => bool) approvals;
        uint256 approvalsCount;
    }
    JoinProposal[] public joinProposals;

    struct WithdrawProposal {
        address account;
        string reason;
        uint256 proposedAt;
        bool executed;
        mapping(address => bool) approvals;
        uint256 approvalsCount;
    }
    WithdrawProposal[] public withdrawProposals;

    function proposeJoin(address account, string memory name, string memory role)
        external
        onlyMember
        returns (uint256 id)
    {
        require(account != address(0), "Invalid account");
        joinProposals.push();
        id = joinProposals.length - 1;
        JoinProposal storage p = joinProposals[id];
        p.account = account;
        p.name = name;
        p.role = role;
        p.proposedAt = block.timestamp;
    }

    function approveJoin(uint256 id) external onlyMember {
        JoinProposal storage p = joinProposals[id];
        require(!p.executed, "Already executed");
        require(!p.approvals[msg.sender], "Already approved");
        p.approvals[msg.sender] = true;
        p.approvalsCount++;
    }

    function executeJoin(uint256 id) external onlyMember {
        JoinProposal storage p = joinProposals[id];
        require(!p.executed, "Already executed");
        require(p.approvalsCount >= approvalsRequired, "Not enough approvals");
        require(!members[p.account].active, "Already a member");

        members[p.account] = Member({active: true, joinedAt: block.timestamp, name: p.name, role: p.role});
        memberList.push(p.account);
        lastHeartbeat[p.account] = block.timestamp;
        p.executed = true;

        // Adjust threshold if using default supermajority logic off-chain; here manual setApprovalsRequired can be used.
        emit MemberJoined(p.account, p.name, p.role);
    }

    function proposeWithdraw(address account, string memory reason)
        external
        onlyMember
        returns (uint256 id)
    {
        require(members[account].active, "Not member");
        withdrawProposals.push();
        id = withdrawProposals.length - 1;
        WithdrawProposal storage p = withdrawProposals[id];
        p.account = account;
        p.reason = reason;
        p.proposedAt = block.timestamp;
    }

    function approveWithdraw(uint256 id) external onlyMember {
        WithdrawProposal storage p = withdrawProposals[id];
        require(!p.executed, "Already executed");
        require(!p.approvals[msg.sender], "Already approved");
        p.approvals[msg.sender] = true;
        p.approvalsCount++;
    }

    function executeWithdraw(uint256 id) external onlyMember {
        WithdrawProposal storage p = withdrawProposals[id];
        require(!p.executed, "Already executed");
        require(p.approvalsCount >= approvalsRequired, "Not enough approvals");
        require(members[p.account].active, "Not member");

        members[p.account].active = false;
        p.executed = true;

        emit MemberWithdrawn(p.account, p.reason);
    }

    function activeMembersCount() public view returns (uint256 n) {
        for (uint256 i = 0; i < memberList.length; i++) {
            if (members[memberList[i]].active) n++;
        }
    }

    // ---------------- Clauses ----------------
    function addClause(
        string memory title,
        string memory descriptorURI,
        ClauseState state
    ) external onlyMember returns (uint256 clauseId) {
        clauses.push(Clause({
            title: title,
            descriptorURI: descriptorURI,
            state: state,
            createdAt: block.timestamp,
            lastUpdatedAt: block.timestamp
        }));
        clauseId = clauses.length - 1;
        emit ClauseAdded(clauseId, title, state);
    }

    function proposeAmendment(
        uint256 clauseId,
        string memory newTitle,
        string memory newDescriptorURI,
        ClauseState newState
    ) external onlyMember returns (uint256 id) {
        require(clauseId < clauses.length, "Invalid clause");
        amendments.push();
        id = amendments.length - 1;
        Amendment storage a = amendments[id];
        a.clauseId = clauseId;
        a.newTitle = newTitle;
        a.newDescriptorURI = newDescriptorURI;
        a.newState = newState;
        a.proposedAt = block.timestamp;
        emit AmendmentProposed(id, clauseId);
    }

    function approveAmendment(uint256 id) external onlyMember {
        Amendment storage a = amendments[id];
        require(!a.executed, "Already executed");
        require(!a.approvals[msg.sender], "Already approved");
        a.approvals[msg.sender] = true;
        a.approvalsCount++;
        emit AmendmentApproved(id, msg.sender, a.approvalsCount);
    }

    function executeAmendment(uint256 id) external onlyMember {
        Amendment storage a = amendments[id];
        require(!a.executed, "Already executed");
        require(a.approvalsCount >= approvalsRequired, "Not enough approvals");

        Clause storage c = clauses[a.clauseId];
        c.title = a.newTitle;
        c.descriptorURI = a.newDescriptorURI;
        c.state = a.newState;
        c.lastUpdatedAt = block.timestamp;

        a.executed = true;

        emit AmendmentExecuted(id);
        emit ClauseStateChanged(a.clauseId, a.newState);
    }

    // ---------------- Breach & Cure ----------------
    function reportBreach(uint256 clauseId, string memory reason)
        external
        onlyMember
        returns (uint256 breachId)
    {
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

    function markCured(uint256 breachId, string memory note) external onlyMember {
        Breach storage b = breaches[breachId];
        require(!b.cured, "Already cured");
        b.cured = true;
        b.curedAt = block.timestamp;
        b.cureNote = note;
        emit BreachCured(breachId, note);
    }

    function arbitrateBreach(uint256 breachId, string memory finding) external onlyArbiter {
        Breach storage b = breaches[breachId];
        b.arbitrated = true;
        b.arbiterFinding = finding;
        emit BreachArbitrated(breachId, finding);
    }

    // ---------------- Views ----------------
    function totalClauses() external view returns (uint256) { return clauses.length; }
    function totalAmendments() external view returns (uint256) { return amendments.length; }
    function totalBreaches() external view returns (uint256) { return breaches.length; }
    function totalMembers() external view returns (uint256) { return memberList.length; }

    // Convenience: check if a "Zero Tariff" clause is Active by label convention
    function zeroTariffActive(uint256 clauseId) external view returns (bool) {
        require(clauseId < clauses.length, "Invalid clause");
        Clause storage c = clauses[clauseId];
        return c.state == ClauseState.Active && _contains(c.title, "Zero Tariff");
    }

    // ---------------- Internal ----------------
    function _defaultSupermajority() internal view returns (uint256) {
        uint256 n = activeMembersCount();
        if (n == 0) return 0;
        // ceil(2n/3)
        uint256 twoThirds = (2 * n + 2) / 3;
        return twoThirds;
    }

    function _contains(string memory a, string memory b) internal pure returns (bool) {
        bytes memory aa = bytes(a);
        bytes memory bb = bytes(b);
        if (bb.length == 0 || bb.length > aa.length) return false;
        for (uint256 i = 0; i <= aa.length - bb.length; i++) {
            bool ok = true;
            for (uint256 j = 0; j < bb.length; j++) {
                if (aa[i + j] != bb[j]) { ok = false; break; }
            }
            if (ok) return true;
        }
        return false;
    }
}
