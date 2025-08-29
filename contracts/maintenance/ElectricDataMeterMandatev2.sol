// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ElectricDataMeterMandate v2
 * @notice Includes model/installer allowlists & tiered rates (off-peak, standard, peak)
 *         ensuring operators shoulder install + levy duties, with public transparency.
 * @dev Prototype for legislative + enforcement use with damay clause funding.
 */
contract ElectricDataMeterMandateV2 {
    address public steward;
    address public regulator;
    address public oracle;

    uint256 public installFeeWei;
    uint256 public penaltyPerDayWei;
    uint256 public tamperFineWei;
    uint256 public communityFund;

    // --- Tiered Rates ---
    struct Rates {
        uint256 offPeakWeiPerKWh;   // Nighttime or low-load hours
        uint256 standardWeiPerKWh;  // Normal daytime
        uint256 peakWeiPerKWh;      // Critical peak hours
    }
    Rates public levyRates;

    // --- Allowlists ---
    mapping(string => bool) public approvedModels;
    mapping(address => bool) public approvedInstallers;

    struct DataCenter {
        string name;
        address operator;
        bool registered;
        bool suspended;
        uint256 totalKWhReported;
        uint256 totalLeviesPaid;
    }

    struct Meter {
        bytes32 meterId;
        address dc;
        address installer;
        string model;
        bool active;
        bool paidInstall;
        bool tamperFlag;
    }

    mapping(address => DataCenter) public dataCenters;
    mapping(bytes32 => Meter) public meters;
    mapping(address => uint256) public operatorDueWei;

    event DataCenterRegistered(address dc, address operator, string name);
    event ModelApproved(string model, bool approved);
    event InstallerApproved(address installer, bool approved);
    event MeterAssigned(bytes32 meterId, address dc, address installer, string model);
    event MeterInstalled(bytes32 meterId, address installer);
    event ConsumptionReported(bytes32 meterId, uint8 tier, uint256 kWh, uint256 levy);
    event FundsWithdrawn(address to, uint256 amount);

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
        uint256 _installFeeWei,
        uint256 _penaltyPerDayWei,
        uint256 _tamperFineWei,
        Rates memory _rates
    ) {
        steward = msg.sender;
        regulator = _regulator;
        oracle = _oracle;
        installFeeWei = _installFeeWei;
        penaltyPerDayWei = _penaltyPerDayWei;
        tamperFineWei = _tamperFineWei;
        levyRates = _rates;
    }

    // --- Allowlist Management ---
    function approveModel(string calldata model, bool approved) external onlyAdmin {
        approvedModels[model] = approved;
        emit ModelApproved(model, approved);
    }

    function approveInstaller(address installer, bool approved) external onlyAdmin {
        approvedInstallers[installer] = approved;
        emit InstallerApproved(installer, approved);
    }

    // --- Data Center & Meter Ops ---
    function registerDataCenter(address dc, address operator, string calldata name) external onlyAdmin {
        dataCenters[dc] = DataCenter(name, operator, true, false, 0, 0);
        emit DataCenterRegistered(dc, operator, name);
    }

    function assignMeter(address dc, bytes32 meterId, address installer, string calldata model) external onlyAdmin {
        require(dataCenters[dc].registered, "DC not registered");
        require(approvedInstallers[installer], "Installer not approved");
        require(approvedModels[model], "Model not approved");
        meters[meterId] = Meter(meterId, dc, installer, model, false, false, false);
        emit MeterAssigned(meterId, dc, installer, model);
    }

    function fundInstall(bytes32 meterId) external payable {
        Meter storage m = meters[meterId];
        require(msg.value == installFeeWei, "Incorrect fee");
        require(msg.sender == dataCenters[m.dc].operator, "Not operator");
        m.paidInstall = true;
    }

    function confirmInstall(bytes32 meterId) external {
        Meter storage m = meters[meterId];
        require(msg.sender == m.installer, "Not installer");
        require(m.paidInstall, "Not funded");
        m.active = true;
        (bool ok,) = payable(m.installer).call{value: installFeeWei}("");
        require(ok, "Payout fail");
        emit MeterInstalled(meterId, m.installer);
    }

    // --- Reporting ---
    /**
     * @param tier 0=off-peak, 1=standard, 2=peak
     */
    function reportConsumption(bytes32 meterId, uint8 tier, uint256 kWh) external onlyOracle {
        Meter storage m = meters[meterId];
        require(m.active, "Inactive meter");
        DataCenter storage dc = dataCenters[m.dc];
        require(dc.registered, "DC not found");
        uint256 rate = tier == 0 ? levyRates.offPeakWeiPerKWh :
                       tier == 1 ? levyRates.standardWeiPerKWh :
                       levyRates.peakWeiPerKWh;
        uint256 levy = kWh * rate;
        operatorDueWei[dc.operator] += levy;
        dc.totalKWhReported += kWh;
        emit ConsumptionReported(meterId, tier, kWh, levy);
    }

    function settleDue() external payable {
        require(msg.value == operatorDueWei[msg.sender], "Incorrect amount");
        communityFund += msg.value;
        operatorDueWei[msg.sender] = 0;
    }

    // --- Community Fund ---
    function withdrawCommunity(address payable to, uint256 amount) external onlyAdmin {
        require(amount <= communityFund, "Insufficient");
        communityFund -= amount;
        (bool ok,) = to.call{value: amount}("");
        require(ok, "Transfer fail");
        emit FundsWithdrawn(to, amount);
    }
}
