// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HousingGuaranteeActV5_1
 * @notice Pabahay with non-compulsory payments, exclusive occupancy, zero-excess credit,
 *         guided liftoff programs, and monthly uplift checks with graduation logic.
 * @dev This is an additive upgrade over V5 focusing on coaching, programs, and SRI tracking.
 */
contract HousingGuaranteeActV5_1 {
    address public steward;
    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }

    constructor() { steward = msg.sender; }

    // --- Roles (minimal) ---
    mapping(address => bool) public coach;
    function setCoach(address w, bool isCoach) external onlySteward { coach[w] = isCoach; }
    modifier onlyCoachOrSteward() { require(coach[msg.sender] || msg.sender == steward, "Not coach/steward"); _; }

    // --- Constants ---
    uint16 public constant SRI_THRESHOLD = 70;     // percent
    uint8  public constant GRADUATE_STREAK = 6;    // months
    uint16 public constant BPS = 10_000;

    // --- Families and occupancy (simplified) ---
    struct Family {
        string headName;
        address wallet;
        bool registered;
        bool allocated;
        uint256 unitId;
        bool activeOccupancy;   // exclusive occupancy guard
        bool graduated;
    }
    mapping(address => Family) public families;

    // --- Programs ---
    enum Program {
        Coaching,
        SkillsTraining,
        StarterGrant,
        ZeroInterestCredit,
        MarketLinkage,
        HealthcareEnrollment,
        ChildcareSupport,
        FoodSecurity,
        SavingsMatch
    }
    mapping(address => mapping(Program => bool)) public programActive;

    // --- Monthly uplift tracking ---
    struct Progress {
        uint16 sri;                 // 0-100
        uint32 lastCheckYYYYMM;     // e.g., 202508
        uint16 monthsEnrolled;
        uint8  streakAboveThreshold;
    }
    mapping(address => Progress) public progress;

    // --- Loan (principal-only) ---
    struct LoanOffer {
        bool offered;
        bool active;
        uint256 amount;
        uint32 termMonths;
        uint256 startDate;
    }
    mapping(address => LoanOffer) public loans;

    // --- Events ---
    event FamilyRegistered(address family, string headName);
    event UnitAllocated(address family, uint256 unitId);
    event ProgramActivated(address family, Program program);
    event MonthlyCheck(address family, uint32 yyyymm, uint16 sri);
    event Graduation(address family, uint32 yyyymm);
    event LoanOffered(address family, uint256 amount, uint32 termMonths);
    event LoanAccepted(address family, uint256 amount);

    // --- Registration & allocation (core) ---
    function registerFamily(address wallet, string calldata headName) external onlySteward {
        families[wallet] = Family(headName, wallet, true, false, 0, false, false);
        emit FamilyRegistered(wallet, headName);
    }

    function allocateUnit(address familyWallet, uint256 unitId) external onlySteward {
        Family storage f = families[familyWallet];
        require(f.registered && !f.allocated, "Ineligible");
        f.allocated = true;
        f.unitId = unitId;
        f.activeOccupancy = true;

        // Auto-activate baseline programs
        programActive[familyWallet][Program.Coaching] = true;
        programActive[familyWallet][Program.HealthcareEnrollment] = true;
        programActive[familyWallet][Program.ZeroInterestCredit] = true;

        // Auto-offer principal-only credit (acceptance is voluntary)
        loans[familyWallet] = LoanOffer(true, false, 50_000 ether, 24, 0);

        emit UnitAllocated(familyWallet, unitId);
        emit ProgramActivated(familyWallet, Program.Coaching);
        emit ProgramActivated(familyWallet, Program.HealthcareEnrollment);
        emit ProgramActivated(familyWallet, Program.ZeroInterestCredit);
        emit LoanOffered(familyWallet, 50_000 ether, 24);
    }

    // --- Program control ---
    function activateProgram(address familyWallet, Program p) public onlyCoachOrSteward {
        programActive[familyWallet][p] = true;
        emit ProgramActivated(familyWallet, p);
    }

    // --- Monthly check & auto-rules ---
    function logMonthlyCheck(
        address familyWallet,
        uint32 yyyymm,
        uint16 sri // 0..100
    ) external onlyCoachOrSteward {
        Family storage f = families[familyWallet];
        require(f.allocated && f.activeOccupancy, "Not active");
        require(sri <= 100, "SRI out of range");

        Progress storage pr = progress[familyWallet];
        // Simple month progression guard: must advance or equal for first entry
        require(yyyymm >= pr.lastCheckYYYYMM, "Backdated check");

        // Update progress
        if (yyyymm > pr.lastCheckYYYYMM) pr.monthsEnrolled += 1;
        pr.lastCheckYYYYMM = yyyymm;
        pr.sri = sri;

        // Streak logic
        if (sri >= SRI_THRESHOLD) {
            pr.streakAboveThreshold += 1;
        } else {
            pr.streakAboveThreshold = 0;
        }

        emit MonthlyCheck(familyWallet, yyyymm, sri);

        // Auto-support rules
        if (sri < 50) {
            activateProgram(familyWallet, Program.SkillsTraining);
            activateProgram(familyWallet, Program.ChildcareSupport);
            activateProgram(familyWallet, Program.FoodSecurity);
        } else if (sri < SRI_THRESHOLD) {
            activateProgram(familyWallet, Program.StarterGrant);
            activateProgram(familyWallet, Program.MarketLinkage);
            activateProgram(familyWallet, Program.SavingsMatch);
        }

        // Graduation
        if (!f.graduated && pr.streakAboveThreshold >= GRADUATE_STREAK) {
            f.graduated = true;
            emit Graduation(familyWallet, yyyymm);
        }
    }

    // --- Loan acceptance (principal-only) ---
    function acceptLoanOffer() external {
        LoanOffer storage l = loans[msg.sender];
        require(l.offered && !l.active, "No available offer");
        l.active = true;
        l.startDate = block.timestamp;
        (bool ok, ) = payable(msg.sender).call{value: l.amount}("");
        require(ok, "Transfer failed");
        emit LoanAccepted(msg.sender, l.amount);
    }

    // --- Depository for loan pool ---
    receive() external payable {}
}
