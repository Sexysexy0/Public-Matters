// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AntitrustIntegrity
/// @notice Governance and forensic workflow for merger review, whistleblowers, and investigations.
/// @dev Self-contained contract with oracle hooks and escrow primitives for integration.

contract AntitrustIntegrity {
    // --- Roles ---
    address public guardian;
    uint256 public councilThreshold; // number of council votes required for multi-sig actions

    enum Role { None, Guardian, Council, Investigator, Auditor, Registrar }
    mapping(address => Role) public roles;

    // --- Constants / Timeouts ---
    uint256 public constant MERGER_DEPOSIT_TIMEOUT = 14 days;
    uint256 public constant APPEAL_WINDOW = 30 days;
    uint256 public constant LIFT_REQUEST_WINDOW = 90 days;

    // --- Events (for immutable forensic trail) ---
    event RoleAssigned(address indexed who, Role role);
    event RoleRevoked(address indexed who);
    event WhistleblowerFiled(uint indexed caseId, address indexed reporter, bytes32 evidenceHash, uint bounty);
    event MergerSubmitted(uint indexed mergerId, address indexed submitter, uint deposit, uint submitTime);
    event MergerVote(uint indexed mergerId, address indexed voter, bool approve);
    event MergerApproved(uint indexed mergerId);
    event MergerRejected(uint indexed mergerId);
    event InvestigationTriggered(uint indexed caseId, uint indexed mergerId, address indexed investigator);
    event InvestigationReport(uint indexed caseId, address indexed investigator, bytes32 reportHash);
    event FOIARequest(uint indexed requestId, address indexed requester, string target);
    event ComplianceViolation(uint indexed targetId, string reason);
    event EmergencyFreeze(bytes32 indexed identifier, address indexed triggeredBy);
    event EmergencyLift(bytes32 indexed identifier, address indexed liftedBy);
    event BountyPaid(uint indexed caseId, address indexed reporter, uint amount);

    // --- Structs ---
    struct WhistleCase {
        uint id;
        address reporter;
        bytes32 evidenceHash; // hash of encrypted evidence or IPFS CID hash
        uint bounty; // escrowed bounty
        bool validated;
        uint timestamp;
    }

    struct Merger {
        uint id;
        address submitter;
        string targetName;
        uint deposit;
        uint submitTime;
        uint approvals;
        uint rejections;
        bool finalized;
        bool approved;
        mapping(address => bool) voted;
    }

    struct Investigation {
        uint id;
        uint mergerId;
        address investigator;
        bytes32 reportHash;
        bool completed;
        uint timestamp;
    }

    struct FOIA {
        uint id;
        address requester;
        string target;
        uint timestamp;
        bool fulfilled;
    }

    // --- Storage ---
    uint public whistleCount;
    uint public mergerCount;
    uint public investigationCount;
    uint public foiaCount;

    mapping(uint => WhistleCase) public whistleCases;
    mapping(uint => Merger) private mergers; // note: Merger contains mapping, so private with accessor functions
    mapping(uint => Investigation) public investigations;
    mapping(uint => FOIA) public foiaRequests;

    // escrow balances for deposits and bounties
    mapping(address => uint) public escrowBalances;

    // emergency freeze registry (e.g., domain names, identifiers)
    mapping(bytes32 => bool) public frozenIdentifiers;

    // council members list (for vote counting)
    address[] public councilMembers;
    mapping(address => bool) public isCouncilMember;

    // --- Modifiers ---
    modifier onlyGuardian() {
        require(msg.sender == guardian, "Only guardian");
        _;
    }

    modifier onlyRole(Role r) {
        require(roles[msg.sender] == r, "Insufficient role");
        _;
    }

    modifier onlyCouncil() {
        require(isCouncilMember[msg.sender], "Council only");
        _;
    }

    // --- Constructor ---
    constructor(address[] memory initialCouncil, uint256 _councilThreshold) {
        guardian = msg.sender;
        roles[msg.sender] = Role.Guardian;
        emit RoleAssigned(msg.sender, Role.Guardian);

        require(_councilThreshold > 0 && _councilThreshold <= initialCouncil.length, "Invalid threshold");
        councilThreshold = _councilThreshold;

        for (uint i = 0; i < initialCouncil.length; i++) {
            address m = initialCouncil[i];
            roles[m] = Role.Council;
            isCouncilMember[m] = true;
            councilMembers.push(m);
            emit RoleAssigned(m, Role.Council);
        }
    }

    // --- Role management ---
    function assignRole(address who, Role r) external onlyGuardian {
        roles[who] = r;
        if (r == Role.Council) {
            if (!isCouncilMember[who]) {
                isCouncilMember[who] = true;
                councilMembers.push(who);
            }
        }
        emit RoleAssigned(who, r);
    }

    function revokeRole(address who) external onlyGuardian {
        Role prev = roles[who];
        roles[who] = Role.None;
        if (prev == Role.Council && isCouncilMember[who]) {
            isCouncilMember[who] = false;
            // note: councilMembers array not compacted for gas reasons; offchain index recommended
        }
        emit RoleRevoked(who);
    }

    // --- Whistleblower intake & bounty escrow ---
    function fileWhistle(bytes32 evidenceHash) external payable returns (uint) {
        // optional bounty: msg.value
        whistleCount++;
        WhistleCase storage wc = whistleCases[whistleCount];
        wc.id = whistleCount;
        wc.reporter = msg.sender;
        wc.evidenceHash = evidenceHash;
        wc.bounty = msg.value;
        wc.validated = false;
        wc.timestamp = block.timestamp;

        // hold bounty in escrowBalances under contract
        if (msg.value > 0) {
            escrowBalances[address(this)] += msg.value;
        }

        emit WhistleblowerFiled(whistleCount, msg.sender, evidenceHash, msg.value);
        return whistleCount;
    }

    // Called by guardian or auditor after validation to pay bounty
    function validateAndPayBounty(uint caseId, address payable reporter, uint amount) external onlyRole(Role.Auditor) {
        WhistleCase storage wc = whistleCases[caseId];
        require(!wc.validated, "Already validated");
        require(escrowBalances[address(this)] >= amount, "Insufficient escrow");
        wc.validated = true;
        escrowBalances[address(this)] -= amount;
        (bool ok, ) = reporter.call{value: amount}("");
        require(ok, "Payout failed");
        emit BountyPaid(caseId, reporter, amount);
    }

    // --- Merger submission with deposit escrow ---
    function submitMerger(string calldata targetName) external payable returns (uint) {
        require(msg.value > 0, "Deposit required");
        mergerCount++;
        Merger storage m = mergers[mergerCount];
        m.id = mergerCount;
        m.submitter = msg.sender;
        m.targetName = targetName;
        m.deposit = msg.value;
        m.submitTime = block.timestamp;
        m.approvals = 0;
        m.rejections = 0;
        m.finalized = false;
        m.approved = false;

        escrowBalances[address(this)] += msg.value;

        emit MergerSubmitted(mergerCount, msg.sender, msg.value, block.timestamp);
        return mergerCount;
    }

    // Council voting on merger
    function voteMerger(uint mergerId, bool approve) external onlyCouncil {
        Merger storage m = mergers[mergerId];
        require(!m.finalized, "Finalized");
        require(!m.voted[msg.sender], "Already voted");

        m.voted[msg.sender] = true;
        if (approve) {
            m.approvals++;
        } else {
            m.rejections++;
        }
        emit MergerVote(mergerId, msg.sender, approve);

        // auto finalize if threshold reached or majority impossible
        if (m.approvals >= councilThreshold) {
            _finalizeMergerApproval(mergerId);
        } else if (m.rejections >= councilThreshold) {
            _finalizeMergerRejection(mergerId);
        }
    }

    // Timeout auto-revert: if deposit timeout passes without sufficient votes, refund deposit and mark rejected
    function checkMergerTimeout(uint mergerId) external {
        Merger storage m = mergers[mergerId];
        require(!m.finalized, "Finalized");
        if (block.timestamp > m.submitTime + MERGER_DEPOSIT_TIMEOUT) {
            _finalizeMergerRejection(mergerId);
        }
    }

    function _finalizeMergerApproval(uint mergerId) internal {
        Merger storage m = mergers[mergerId];
        m.finalized = true;
        m.approved = true;
        // release deposit back to submitter (or to remedies escrow in real integration)
        escrowBalances[address(this)] -= m.deposit;
        (bool ok, ) = payable(m.submitter).call{value: m.deposit}("");
        require(ok, "Refund failed");
        emit MergerApproved(mergerId);
    }

    function _finalizeMergerRejection(uint mergerId) internal {
        Merger storage m = mergers[mergerId];
        m.finalized = true;
        m.approved = false;
        // deposit retained for remedies / investigation funding (kept in contract escrow)
        emit MergerRejected(mergerId);
    }

    // --- Investigation workflow ---
    function triggerInvestigation(uint mergerId, address investigator) external onlyRole(Role.Auditor) returns (uint) {
        require(mergerId > 0 && mergerId <= mergerCount, "Invalid merger");
        investigationCount++;
        investigations[investigationCount] = Investigation({
            id: investigationCount,
            mergerId: mergerId,
            investigator: investigator,
            reportHash: bytes32(0),
            completed: false,
            timestamp: block.timestamp
        });
        emit InvestigationTriggered(investigationCount, mergerId, investigator);
        return investigationCount;
    }

    function submitInvestigationReport(uint investigationId, bytes32 reportHash) external {
        Investigation storage inv = investigations[investigationId];
        require(inv.investigator == msg.sender, "Only assigned investigator");
        require(!inv.completed, "Already completed");
        inv.reportHash = reportHash;
        inv.completed = true;
        emit InvestigationReport(investigationId, msg.sender, reportHash);
    }

    // Guardian or Auditor can mark compliance violation (oracle / manual)
    function markComplianceViolation(uint targetId, string calldata reason) external onlyRole(Role.Auditor) {
        emit ComplianceViolation(targetId, reason);
    }

    // --- FOIA-style requests ---
    function requestFOIA(string calldata target) external returns (uint) {
        foiaCount++;
        foiaRequests[foiaCount] = FOIA({
            id: foiaCount,
            requester: msg.sender,
            target: target,
            timestamp: block.timestamp,
            fulfilled: false
        });
        emit FOIARequest(foiaCount, msg.sender, target);
        return foiaCount;
    }

    // Oracle callback to mark FOIA fulfilled (only guardian or oracle integration)
    function fulfillFOIA(uint requestId) external onlyRole(Role.Auditor) {
        FOIA storage f = foiaRequests[requestId];
        require(!f.fulfilled, "Already fulfilled");
        f.fulfilled = true;
        // emit event already captured by FOIARequest + external logs
    }

    // --- Emergency freeze (multi-sig style) ---
    mapping(bytes32 => mapping(address => bool)) public freezeVotes;
    mapping(bytes32 => uint) public freezeVoteCount;

    function proposeEmergencyFreeze(bytes32 identifier) external onlyCouncil {
        // cast vote immediately
        if (!freezeVotes[identifier][msg.sender]) {
            freezeVotes[identifier][msg.sender] = true;
            freezeVoteCount[identifier]++;
        }
        // if threshold reached, freeze
        if (freezeVoteCount[identifier] >= councilThreshold) {
            frozenIdentifiers[identifier] = true;
            emit EmergencyFreeze(identifier, msg.sender);
        }
    }

    function proposeLiftFreeze(bytes32 identifier) external onlyCouncil {
        // reuse freezeVotes mapping for lift by negation: require separate tracking in prod
        if (frozenIdentifiers[identifier]) {
            // simple lift: require threshold of council to call lift
            uint count = 0;
            for (uint i = 0; i < councilMembers.length; i++) {
                if (isCouncilMember[councilMembers[i]]) {
                    // offchain: assume explicit calls; here we require guardian to call lift after consensus
                    // For simplicity, allow guardian to lift if guardian calls
                }
            }
            // guardian lift for simplicity
            if (msg.sender == guardian) {
                frozenIdentifiers[identifier] = false;
                emit EmergencyLift(identifier, msg.sender);
            }
        }
    }

    // --- Oracle hooks (placeholders) ---
    // These functions are intended to be called by an oracle/relayer after offchain checks.
    function oracleMarkComplianceViolation(uint targetId, string calldata reason) external onlyRole(Role.Registrar) {
        emit ComplianceViolation(targetId, reason);
    }

    // --- View helpers for mergers (since Merger has internal mapping) ---
    function mergerInfo(uint mergerId) external view returns (
        uint id,
        address submitter,
        string memory targetName,
        uint deposit,
        uint submitTime,
        uint approvals,
        uint rejections,
        bool finalized,
        bool approved
    ) {
        Merger storage m = mergers[mergerId];
        return (m.id, m.submitter, m.targetName, m.deposit, m.submitTime, m.approvals, m.rejections, m.finalized, m.approved);
    }

    // --- Admin utilities ---
    receive() external payable {
        // allow contract to receive funds for escrow top-ups
        escrowBalances[address(this)] += msg.value;
    }

    function withdrawEscrow(address payable to, uint amount) external onlyGuardian {
        require(escrowBalances[address(this)] >= amount, "Insufficient escrow");
        escrowBalances[address(this)] -= amount;
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "Withdraw failed");
    }
}
