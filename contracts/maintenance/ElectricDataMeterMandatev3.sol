// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ElectricDataMeterMandate v3 — Monthly Audit Extension
 * @notice Builds on v2 with automated monthly audit summary emitters for full public transparency.
 * @dev Intended for LGU/regulator + community monitoring; damay clause stays active.
 */
contract ElectricDataMeterMandateV3_Audit {
    address public steward;
    address public regulator;
    address public oracle;

    uint256 public communityFund;
    uint256 public auditMonth; // YYYYMM format

    struct DataCenter {
        string name;
        address operator;
        bool registered;
        bool suspended;
        uint256 totalKWhThisMonth;
        uint256 totalLevyThisMonth;
    }

    mapping(address => DataCenter) public dataCenters;
    mapping(address => uint256) public operatorDueWei;

    event DataCenterRegistered(address dc, address operator, string name);
    event ConsumptionReported(address dc, uint256 kWh, uint256 levy);
    event MonthlyAuditPublished(uint256 month, AuditEntry[] entries);

    struct AuditEntry {
        string name;
        address operator;
        uint256 kWh;
        uint256 levy;
        bool suspended;
    }

    modifier onlyAdmin() {
        require(msg.sender == steward || msg.sender == regulator, "Not admin");
        _;
    }
    modifier onlyOracle() {
        require(msg.sender == oracle, "Not oracle");
        _;
    }

    constructor(address _regulator, address _oracle) {
        steward = msg.sender;
        regulator = _regulator;
        oracle = _oracle;
        auditMonth = _currentYYYYMM();
    }

    function registerDataCenter(address dc, address operator, string calldata name) external onlyAdmin {
        dataCenters[dc] = DataCenter(name, operator, true, false, 0, 0);
        emit DataCenterRegistered(dc, operator, name);
    }

    function reportConsumption(address dc, uint256 kWh, uint256 levy) external onlyOracle {
        require(dataCenters[dc].registered, "DC not found");
        DataCenter storage d = dataCenters[dc];
        d.totalKWhThisMonth += kWh;
        d.totalLevyThisMonth += levy;
        operatorDueWei[d.operator] += levy;
        emit ConsumptionReported(dc, kWh, levy);
    }

    // Publishes the audit for the current month and resets counters
    function publishMonthlyAudit() external onlyAdmin {
        require(auditMonth == _currentYYYYMM(), "Audit month mismatch — wait until period end");

        // Build audit entries
        AuditEntry[] memory entries = new AuditEntry[](_countDCs());
        uint256 idx = 0;

        for (uint256 i = 0; i < _dcKeys.length; i++) {
            address dc = _dcKeys[i];
            DataCenter storage d = dataCenters[dc];
            if (!d.registered) continue;

            entries[idx] = AuditEntry({
                name: d.name,
                operator: d.operator,
                kWh: d.totalKWhThisMonth,
                levy: d.totalLevyThisMonth,
                suspended: d.suspended
            });

            // Reset monthly counters after publish
            d.totalKWhThisMonth = 0;
            d.totalLevyThisMonth = 0;
            idx++;
        }

        emit MonthlyAuditPublished(auditMonth, entries);

        // Advance to next month
        auditMonth = _currentYYYYMM();
    }

    // --- Internal tracking of DC keys (simplified for example) ---
    address[] private _dcKeys;
    function _countDCs() internal view returns (uint256) {
        return _dcKeys.length;
    }

    // Utility to get YYYYMM
    function _currentYYYYMM() internal view returns (uint256) {
        (uint year, uint month, ) = _timestampToDate(block.timestamp);
        return year * 100 + month;
    }

    // Date conversion util
    function _timestampToDate(uint timestamp) internal pure returns (uint year, uint month, uint day) {
        uint z = timestamp / 86400 + 719468;
        uint era = (z >= 0 ? z : z - 146096) / 146097;
        uint doe = z - era * 146097;
        uint yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365;
        year = yoe + era * 400;
        uint doy = doe - (365*yoe + yoe/4 - yoe/100);
        uint mp = (5*doy + 2)/153;
        day = doy - (153*mp+2)/5 + 1;
        month = mp + (mp < 10 ? 3 : -9);
        year = year + (month <= 2 ? 1 : 0);
    }
}
