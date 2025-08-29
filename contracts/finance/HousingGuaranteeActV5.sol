// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HousingGuaranteeActV5
 * @notice Non-compulsory yearly payment tracking, occupancy-only title hold,
 *         and post-allocation livelihood loan offers with zero excess interest.
 */
contract HousingGuaranteeActV5 {
    address public steward;
    uint16 public constant BPS = 10_000;

    enum UnitStatus { Available, Occupied }
    enum LoanStatus { None, Offered, Active, Closed }

    struct Family {
        string headName;
        address wallet;
        bool registered;
        bool allocated;
        uint256 unitId;
        uint256 lastReceiptYear;
        bool activeOccupancy;
    }

    struct Unit {
        uint256 id;
        string location;
        address developer;
        UnitStatus status;
        address occupant;
        bool titleIssued;
    }

    struct LoanOffer {
        LoanStatus status;
        uint256 amount;
        uint256 annualInterestBps; // should be 0 for zero excess interest
        uint256 termMonths;
        uint256 startDate;
    }

    mapping(address => Family) public families;
    mapping(uint256 => Unit) public units;
    mapping(address => LoanOffer) public loans;

    uint256 public unitCount;

    event FamilyRegistered(address wallet, string headName);
    event UnitAdded(uint256 unitId, string location, address developer);
    event UnitAllocated(uint256 unitId, address family);
    event YearlyReceiptLogged(address family, uint256 year, uint256 amount);
    event LoanOffered(address family, uint256 amount, uint256 termMonths);
    event LoanAccepted(address family, uint256 amount);
    event LoanClosed(address family);

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }

    constructor() { steward = msg.sender; }

    // Registration
    function registerFamily(address wallet, string calldata headName) external onlySteward {
        families[wallet] = Family(headName, wallet, true, false, 0, 0, false);
        emit FamilyRegistered(wallet, headName);
    }

    function addUnit(string calldata location, address developer) external onlySteward {
        unitCount++;
        units[unitCount] = Unit(unitCount, location, developer, UnitStatus.Available, address(0), false);
        emit UnitAdded(unitCount, location, developer);
    }

    function allocateUnit(address familyWallet, uint256 unitId) external onlySteward {
        Family storage f = families[familyWallet];
        Unit storage u = units[unitId];
        require(f.registered && !f.allocated, "Family not eligible/free");
        require(u.status == UnitStatus.Available, "Unit not available");

        f.allocated = true;
        f.unitId = unitId;
        f.activeOccupancy = true;

        u.status = UnitStatus.Occupied;
        u.occupant = familyWallet;

        // Automatically offer livelihood loan
        loans[familyWallet] = LoanOffer(LoanStatus.Offered, 50_000 ether, 0, 24, 0);

        emit UnitAllocated(unitId, familyWallet);
        emit LoanOffered(familyWallet, 50_000 ether, 24);
    }

    // Yearly payment receipt tracking (optional)
    function logYearlyReceipt(address familyWallet, uint256 year, uint256 amount) external onlySteward {
        Family storage f = families[familyWallet];
        require(f.activeOccupancy, "Not in occupancy");
        f.lastReceiptYear = year;
        emit YearlyReceiptLogged(familyWallet, year, amount);
    }

    // Loans
    function acceptLoanOffer() external {
        LoanOffer storage l = loans[msg.sender];
        require(l.status == LoanStatus.Offered, "No offer");
        l.status = LoanStatus.Active;
        l.startDate = block.timestamp;
        // Transfer loan amount to family
        (bool ok, ) = payable(msg.sender).call{value: l.amount}("");
        require(ok, "Transfer failed");
        emit LoanAccepted(msg.sender, l.amount);
    }

    function closeLoan() external onlySteward {
        LoanOffer storage l = loans[msg.sender];
        require(l.status == LoanStatus.Active, "Not active");
        l.status = LoanStatus.Closed;
        emit LoanClosed(msg.sender);
    }

    // Occupancy guard: cannot transfer title until land paid in full
    function markLandFullyPaid(uint256 unitId) external onlySteward {
        Unit storage u = units[unitId];
        require(u.status == UnitStatus.Occupied, "Not occupied");
        u.titleIssued = true;
    }

    receive() external payable {}
}
