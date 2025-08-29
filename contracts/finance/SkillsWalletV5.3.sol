// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SkillsWalletV53
 * @notice Verifiable skills, employment, and community task pay for HousingGuaranteeAct stack.
 * @dev Minimal, privacy-first. Emits signals for monthly uplift checks (off-chain blend to SRI).
 */
contract SkillsWalletV53 {
    address public steward;

    constructor(uint256 _minWagePerHourWei) {
        steward = msg.sender;
        minWagePerHourWei = _minWagePerHourWei;
    }

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }

    // --- Roles ---
    mapping(address => bool) public isCoach;
    mapping(address => bool) public isEmployer;
    mapping(address => bool) public isAgency;
    mapping(address => bool) public isSupervisor;

    function setRole(address w, uint8 role, bool val) external onlySteward {
        if (role == 1) isCoach[w] = val;
        else if (role == 2) isEmployer[w] = val;
        else if (role == 3) isAgency[w] = val;
        else if (role == 4) isSupervisor[w] = val;
        else revert("Invalid role");
    }

    modifier onlyCoachOrAgency() { require(isCoach[msg.sender] || isAgency[msg.sender], "Not coach/agency"); _; }
    modifier onlyEmployerOrAgency() { require(isEmployer[msg.sender] || isAgency[msg.sender], "Not employer/agency"); _; }
    modifier onlySupervisorOrAgency() { require(isSupervisor[msg.sender] || isAgency[msg.sender], "Not supervisor/agency"); _; }

    // --- Persons ---
    struct Person {
        string name;
        bool registered;
        bool consent; // user consents to receive verifiable attestations & payments
    }
    mapping(address => Person) public persons;

    event PersonRegistered(address wallet, string name, bool consent);

    function registerPerson(address wallet, string calldata name, bool consent) external onlySteward {
        persons[wallet] = Person(name, true, consent);
        emit PersonRegistered(wallet, name, consent);
    }

    // --- Badges (skills) ---
    struct Badge {
        bytes32 skillId;     // hashed descriptor (e.g., keccak256("Welding-CarbonSteel"))
        uint8 level;         // 1..5
        address issuer;      // coach/agency
        uint256 issuedAt;
        bytes32 metaHash;    // pointer to syllabus/cert hash (IPFS/URI hashed off-chain)
    }
    mapping(address => Badge[]) public badges;

    event TrainingBadgeIssued(address subject, bytes32 skillId, uint8 level, address issuer);

    function issueTrainingBadge(
        address subject,
        bytes32 skillId,
        uint8 level,
        bytes32 metaHash
    ) external onlyCoachOrAgency {
        require(persons[subject].registered && persons[subject].consent, "Subject not ready");
        require(level >= 1 && level <= 5, "Level range 1..5");
        badges[subject].push(Badge(skillId, level, msg.sender, block.timestamp, metaHash));
        emit TrainingBadgeIssued(subject, skillId, level, msg.sender);
        emitSRISignal(subject);
    }

    // --- Employment claims ---
    enum EmploymentStatus { Interview, Hired, Ended }

    struct EmploymentClaim {
        bytes32 employerIdHash; // hashed employer identity
        EmploymentStatus status;
        uint32 daysCommitted;   // planned or completed days
        address issuer;         // employer/agency
        uint256 timestamp;
        bytes32 metaHash;       // contract summary, role code, etc.
    }
    mapping(address => EmploymentClaim[]) public employment;

    event EmploymentLogged(address subject, bytes32 employerIdHash, EmploymentStatus status);

    function logEmployment(
        address subject,
        bytes32 employerIdHash,
        EmploymentStatus status,
        uint32 daysCommitted,
        bytes32 metaHash
    ) external onlyEmployerOrAgency {
        require(persons[subject].registered && persons[subject].consent, "Subject not ready");
        employment[subject].push(EmploymentClaim(employerIdHash, status, daysCommitted, msg.sender, block.timestamp, metaHash));
        emit EmploymentLogged(subject, employerIdHash, status);
        emitSRISignal(subject);
    }

    // --- Community task + pay ---
    uint256 public minWagePerHourWei; // configurable floor
    function setMinWagePerHourWei(uint256 v) external onlySteward { minWagePerHourWei = v; }

    struct TaskLog {
        bytes32 taskId;     // e.g., "BRGY8-CleanUp-2025-08-29-AM"
        uint8 hours;        // 1..12
        uint256 payWei;     // pay credited
        address issuer;     // supervisor/agency
        uint256 timestamp;
        bytes32 metaHash;   // description/reference hash
    }
    mapping(address => TaskLog[]) public tasks;
    mapping(address => uint256) public balances; // claimable Bayanihan Pay

    event CommunityTaskRecorded(address subject, bytes32 taskId, uint8 hours, uint256 payWei);
    event WageRejected(address issuer, uint256 offered, uint256 requiredFloor);
    event Withdrawn(address subject, uint256 amount);

    function recordCommunityTask(
        address subject,
        bytes32 taskId,
        uint8 hours,
        uint256 payWei,
        bytes32 metaHash
    ) external onlySupervisorOrAgency {
        require(persons[subject].registered && persons[subject].consent, "Subject not ready");
        require(hours >= 1 && hours <= 12, "Hours 1..12");
        uint256 floor = minWagePerHourWei * hours;
        require(address(this).balance >= payWei, "Insufficient pool");
        if (payWei < floor) {
            emit WageRejected(msg.sender, payWei, floor);
            revert("Below wage floor");
        }
        tasks[subject].push(TaskLog(taskId, hours, payWei, msg.sender, block.timestamp, metaHash));
        balances[subject] += payWei;
        emit CommunityTaskRecorded(subject, taskId, hours, payWei);
        emitSRISignal(subject);
    }

    function withdrawBalance() external {
        uint256 amt = balances[msg.sender];
        require(amt > 0, "No balance");
        balances[msg.sender] = 0;
        (bool ok, ) = payable(msg.sender).call{value: amt}("");
        require(ok, "Transfer failed");
        emit Withdrawn(msg.sender, amt);
    }

    // --- Signals for monthly checks (off-chain interprets to SRI deltas) ---
    event SRISignal(address subject, uint16 skillsScore0to100, uint16 workDaysLast30);

    function computeSkillSignal(address subject) public view returns (uint16 skillsScore0to100, uint16 workDaysLast30) {
        // Skills: weight higher levels more
        Badge[] memory bs = badges[subject];
        uint256 s1; uint256 s2; uint256 s3; uint256 s4; uint256 s5;
        for (uint256 i=0; i<bs.length; i++) {
            if (bs[i].level == 1) s1++;
            else if (bs[i].level == 2) s2++;
            else if (bs[i].level == 3) s3++;
            else if (bs[i].level == 4) s4++;
            else if (bs[i].level == 5) s5++;
        }
        uint256 raw = 20*s1 + 25*s2 + 35*s3 + 45*s4 + 60*s5; // V5.3 heuristic
        if (raw > 100) raw = 100;
        skillsScore0to100 = uint16(raw);

        // WorkDaysLast30: count task logs with >=4h in last 30 days
        TaskLog[] memory tl = tasks[subject];
        uint256 w = 0;
        uint256 cutoff = block.timestamp - 30 days;
        for (uint256 j=0; j<tl.length; j++) {
            if (tl[j].timestamp >= cutoff && tl[j].hours >= 4) w++;
        }
        if (w > type(uint16).max) w = type(uint16).max;
        workDaysLast30 = uint16(w);
    }

    function emitSRISignal(address subject) internal {
        (uint16 s, uint16 w) = computeSkillSignal(subject);
        emit SRISignal(subject, s, w);
    }

    // --- Funding pool for Bayanihan Pay ---
    receive() external payable {}
}
