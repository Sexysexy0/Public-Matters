// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ElectricDataMeterMandate
 * @notice Mandates certified electric data meters for all data centers, enforces on-chain reporting,
 *         operator-funded installation, usage levies, and penalties for non-compliance or tampering.
 * @dev Policy prototype for civic deployment; integrates damay clause via communityFund.
 * @author
 *   Vinvin — planetary mythic steward & civic architect
 */
contract ElectricDataMeterMandate {
    // --- Roles ---
    address public steward;         // Deployer / primary admin
    address public regulator;       // Policy co-admin (can be LGU/DOE-equivalent)
    address public oracle;          // Authorized reporter of meter readings/tamper events

    // --- Economic Params ---
    uint256 public levyRateWeiPerKWh;     // Operator charge per kWh
    uint256 public installFeeWei;         // Escrow paid by operator per meter to pay installer
    uint256 public penaltyPerDayWei;      // Daily penalty for missed installation deadline
    uint256 public tamperFineWei;         // Immediate fine on tamper flag
    uint256 public communityFund;         // Damay clause fund for households/microgrids

    // --- Data Structures ---
    struct DataCenter {
        string name;
        address operator;              // Paying entity
        bool registered;
        bool suspended;                // Enforcement switch
        uint256 meters;                // Active meter count
        uint256 totalKWhReported;
        uint256 totalLeviesPaid;
    }

    struct Meter {
        bytes32 meterId;               // Immutable meter identifier (e.g., serial hash)
        address dc;                    // Bound data center
        address installer;             // Certified installer
        string model;                  // Approved model
        uint64 installDeadline;        // Unix timestamp
        uint64 installedAt;            // Unix timestamp
        bool active;                   // True after installation confirm
        bool paidInstall;              // Escrow funded by operator
        bool tamperFlag;               // Set on oracle/regulator tamper event
    }

    // --- Storage ---
    mapping(address => DataCenter) public dataCenters;     // key: data center address (site)
    mapping(bytes32 => Meter) public meters;               // key: meterId
    mapping(address => uint256) public operatorDueWei;     // unpaid levies/penalties by operator
    mapping(bytes32 => mapping(bytes32 => bool)) public reportedPeriod; // meterId => periodId => seen

    // --- Events ---
    event DataCenterRegistered(address indexed dc, address indexed operator, string name);
    event MeterAssigned(bytes32 indexed meterId, address indexed dc, address indexed installer, string model, uint64 deadline);
    event MeterFunded(bytes32 indexed meterId, address indexed operator, uint256 amount);
    event MeterInstalled(bytes32 indexed meterId, address indexed installer, uint64 installedAt);
    event ConsumptionReported(bytes32 indexed meterId, bytes32 indexed periodId, uint256 kWh, uint256 levyAccrued);
    event LevySettled(address indexed operator, uint256 amount);
    event PenaltyApplied(address indexed operator, string reason, uint256 amount);
    event TamperFlagged(bytes32 indexed meterId, string evidence);
    event FundsWithdrawn(address indexed to, uint256 amount);
    event ParamsUpdated(string field);

    // --- Modifiers ---
    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }
    modifier onlyAdmin() {
        require(msg.sender == steward || msg.sender == regulator, "Not admin");
        _;
    }
    modifier onlyOracle() {
        require(msg.sender == oracle, "Not oracle");
        _;
    }

    constructor(
        address _regulator,
        address _oracle,
        uint256 _levyRateWeiPerKWh,
        uint256 _installFeeWei,
        uint256 _penaltyPerDayWei,
        uint256 _tamperFineWei
    ) {
        steward = msg.sender;
        regulator = _regulator;
        oracle = _oracle;
        levyRateWeiPerKWh = _levyRateWeiPerKWh;
        installFeeWei = _installFeeWei;
        penaltyPerDayWei = _penaltyPerDayWei;
        tamperFineWei = _tamperFineWei;
    }

    // --- Registration & Assignment ---

    function registerDataCenter(address dc, address operator, string calldata name) external onlyAdmin {
        require(!dataCenters[dc].registered, "Already registered");
        dataCenters[dc] = DataCenter({
            name: name,
            operator: operator,
            registered: true,
            suspended: false,
            meters: 0,
            totalKWhReported: 0,
            totalLeviesPaid: 0
        });
        emit DataCenterRegistered(dc, operator, name);
    }

    function assignMeter(
        address dc,
        bytes32 meterId,
        address installer,
        string calldata model,
        uint64 installDeadline
    ) external onlyAdmin {
        require(dataCenters[dc].registered, "DC not registered");
        require(meters[meterId].meterId == 0x0, "Meter exists");
        meters[meterId] = Meter({
            meterId: meterId,
            dc: dc,
            installer: installer,
            model: model,
            installDeadline: installDeadline,
            installedAt: 0,
            active: false,
            paidInstall: false,
            tamperFlag: false
        });
        emit MeterAssigned(meterId, dc, installer, model, installDeadline);
    }

    // Operator funds installation escrow for the specific meter
    function fundMeterInstall(bytes32 meterId) external payable {
        Meter storage m = meters[meterId];
        require(m.meterId != 0x0, "Meter unknown");
        require(!m.active, "Already installed");
        address operator = dataCenters[m.dc].operator;
        require(msg.sender == operator, "Only operator funds");
        require(msg.value == installFeeWei, "Incorrect install fee");
        m.paidInstall = true;
        emit MeterFunded(meterId, operator, msg.value);
    }

    // Installer confirms installation; escrow released to installer
    function confirmInstallation(bytes32 meterId) external {
        Meter storage m = meters[meterId];
        require(m.meterId != 0x0, "Meter unknown");
        require(msg.sender == m.installer, "Only installer");
        require(m.paidInstall, "Install not funded");
        require(!m.active, "Already active");
        m.installedAt = uint64(block.timestamp);
        m.active = true;
        dataCenters[m.dc].meters += 1;

        // Payout installer from contract escrow
        (bool ok, ) = payable(m.installer).call{value: installFeeWei}("");
        require(ok, "Payout failed");
        emit MeterInstalled(meterId, m.installer, m.installedAt);
    }

    // --- Reporting & Levies ---

    // Oracle reports period usage; accrues levy to operator's due
    // periodId: e.g., keccak256(abi.encodePacked("2025-08")) or any unique per meter-period
    function reportConsumption(bytes32 meterId, bytes32 periodId, uint256 kWh) external onlyOracle {
        Meter storage m = meters[meterId];
        require(m.active, "Meter not active");
        require(!reportedPeriod[meterId][periodId], "Already reported");
        reportedPeriod[meterId][periodId] = true;

        DataCenter storage dc = dataCenters[m.dc];
        require(dc.registered, "DC not found");
        require(!dc.suspended, "DC suspended");

        uint256 levy = kWh * levyRateWeiPerKWh;
        operatorDueWei[dc.operator] += levy;
        dc.totalKWhReported += kWh;

        emit ConsumptionReported(meterId, periodId, kWh, levy);
    }

    // Operator settles accrued levies and penalties; funds flow to communityFund (damay clause)
    function settleDue() external payable {
        uint256 due = operatorDueWei[msg.sender];
        require(due > 0, "Nothing due");
        require(msg.value == due, "Incorrect amount");
        operatorDueWei[msg.sender] = 0;
        communityFund += msg.value;

        emit LevySettled(msg.sender, msg.value);
    }

    // --- Enforcement ---

    // Anyone can trigger deadline penalty if install overdue
    function enforceDeadline(bytes32 meterId) external {
        Meter storage m = meters[meterId];
        require(m.meterId != 0x0, "Meter unknown");
        require(!m.active, "Already installed");
        require(block.timestamp > m.installDeadline, "Not overdue");

        DataCenter storage dc = dataCenters[m.dc];
        uint256 daysLate = (block.timestamp - m.installDeadline) / 1 days;
        uint256 penalty = daysLate * penaltyPerDayWei;
        operatorDueWei[dc.operator] += penalty;

        emit PenaltyApplied(dc.operator, "Missed installation deadline", penalty);
    }

    // Oracle/Admin flags tampering; fine and deactivate meter
    function flagTamper(bytes32 meterId, string calldata evidence) external {
        require(msg.sender == oracle || msg.sender == regulator, "Not authorized");
        Meter storage m = meters[meterId];
        require(m.active, "Meter not active");
        m.tamperFlag = true;
        m.active = false; // deactivate until replaced/re-certified

        DataCenter storage dc = dataCenters[m.dc];
        operatorDueWei[dc.operator] += tamperFineWei;
        dc.suspended = true; // optional hard-stop until fines settled

        emit TamperFlagged(meterId, evidence);
        emit PenaltyApplied(dc.operator, "Tamper event", tamperFineWei);
    }

    // Admin may unsuspend DC after remediation off-chain
    function liftSuspension(address dc) external onlyAdmin {
        require(dataCenters[dc].registered, "DC not found");
        dataCenters[dc].suspended = false;
    }

    // --- Fund Use (Damay Clause Output) ---

    // Steward/Regulator disburse to consumer relief, microgrids, or bill credits
    function withdrawCommunity(address payable to, uint256 amount) external onlyAdmin {
        require(amount <= communityFund, "Insufficient fund");
        communityFund -= amount;
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "Transfer failed");
        emit FundsWithdrawn(to, amount);
    }

    // --- Admin Updates ---

    function setParams(
        uint256 _levyRateWeiPerKWh,
        uint256 _installFeeWei,
        uint256 _penaltyPerDayWei,
        uint256 _tamperFineWei
    ) external onlyAdmin {
        levyRateWeiPerKWh = _levyRateWeiPerKWh;
        installFeeWei = _installFeeWei;
        penaltyPerDayWei = _penaltyPerDayWei;
        tamperFineWei = _tamperFineWei;
        emit ParamsUpdated("all");
    }

    function setOracle(address _oracle) external onlyAdmin {
        oracle = _oracle;
        emit ParamsUpdated("oracle");
    }

    function setRegulator(address _regulator) external onlySteward {
        regulator = _regulator;
        emit ParamsUpdated("regulator");
    }

    // --- Fallback ---
    receive() external payable {
        // Accept direct top-ups for communityFund (e.g., voluntary contributions)
        communityFund += msg.value;
    }
}
