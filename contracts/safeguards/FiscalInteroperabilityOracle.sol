// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FiscalInteroperabilityOracle
/// @notice Safeguard contract to monitor macro-economic policy compliance, audit structural spending limits, and maintain fiscal anchor discipline
contract FiscalInteroperabilityOracle {
    event MacroMetricsUpdated(uint256 indexed year, uint256 realGdpGrowth, uint256 inflationRate, uint256 debtToGdpRatio);
    event StabilityAnchorTriggered(string metricBreached, uint256 currentMetricValue);
    event FiscalDeviationFlagged(address indexed reportingNode, string deviationDetails);
    event GovernanceAuthorityTransferred(address indexed oldGovernor, address indexed newGovernor);

    address public policyGovernor;
    bool public fiscalDisciplineLockActive;
    
    // Safety thresholds aligned with international threshold baseline data parameters
    uint256 public constant MAX_DEBT_THRESHOLD = 70; // 70% international threshold limit for debt-to-GDP
    uint256 public constant INFLATION_CEILING = 4;   // Upper target range ceiling of 4%
    uint256 public constant INFLATION_FLOOR = 2;     // Lower target range floor of 2%

    struct MacroMetricPacket {
        uint256 realGdpGrowth;    // In basis points (e.g., 500 = 5.0%)
        uint256 inflationRate;    // In basis points (e.g., 280 = 2.8%)
        uint256 debtToGdpRatio;   // Percentage format
        uint256 recordedAtBlock;
        bool isVerified;
    }

    // Mapping from year tracker to economic metric state profiles
    mapping(uint256 => MacroMetricPacket) public historicalMetricsRegistry;
    // Mapping from verified oracle node to authorization approval status
    mapping(address => bool) public certifiedOracleNodes;

    constructor() {
        policyGovernor = msg.sender;
        fiscalDisciplineLockActive = true;
    }

    modifier onlyGovernor() {
        require(msg.sender == policyGovernor, "Unauthorized: Policy Governor verification failed");
        _;
    }

    modifier onlyCertifiedNode() {
        require(certifiedOracleNodes[msg.sender] || msg.sender == policyGovernor, "Access Denied: Node not recognized inside certified registry");
        _;
    }

    /// @notice Enroll a verified investor relations group or official administrative data feed node
    function authorizeOracleNode(address _node, bool _status) external onlyGovernor {
        require(_node != address(0), "Invalid node configuration parameters");
        certifiedOracleNodes[_node] = _status;
    }

    /// @notice Update macro stability parameter state data inside system memory structures
    /// @param _year Target evaluation calendar tracking year
    /// @param _gdpGrowth Real GDP growth metric scaled in basis points
    /// @param _inflation Current headline inflation tracking metric scaled in basis points
    /// @param _debtRatio Combined national government debt-to-GDP percentage tracking register
    function submitMacroParameters(
        uint256 _year,
        uint256 _gdpGrowth,
        uint256 _inflation,
        uint256 _debtRatio
    ) external onlyCertifiedNode {
        require(_year >= 2023, "Historical calibration parameters must scale forward from 2023 base");
        
        historicalMetricsRegistry[_year] = MacroMetricPacket({
            realGdpGrowth: _gdpGrowth,
            inflationRate: _inflation,
            debtToGdpRatio: _debtRatio,
            recordedAtBlock: block.number,
            isVerified: true
        });

        emit MacroMetricsUpdated(_year, _gdpGrowth, _inflation, _debtRatio);

        // Enforce Fiscal Discipline: Circuit-breaker checks against structural thresholds
        if (fiscalDisciplineLockActive) {
            if (_debtRatio > MAX_DEBT_THRESHOLD) {
                emit StabilityAnchorTriggered("Debt-to-GDP Threshold Exceeded", _debtRatio);
            }
            if (_inflation > (INFLATION_CEILING * 100) || _inflation < (INFLATION_FLOOR * 100)) {
                emit StabilityAnchorTriggered("Inflation Target Range Breach", _inflation);
            }
        }
    }

    /// @notice Read-only validation validation sequence for verified investment destination criteria
    function evaluateMarketViability(uint256 _year) external view returns (bool stableFoundation, string memory assessment) {
        MacroMetricPacket memory packet = historicalMetricsRegistry[_year];
        if (!packet.isVerified) {
            return (false, "Data missing inside structural metrics registry");
        }

        bool inflationSafe = (packet.inflationRate <= (INFLATION_CEILING * 100) && packet.inflationRate >= (INFLATION_FLOOR * 100));
        bool debtSafe = (packet.debtToGdpRatio <= MAX_DEBT_THRESHOLD);

        if (inflationSafe && debtSafe && packet.realGdpGrowth > 0) {
            return (true, "Macroeconomic environment demonstrates smart spending and solid fundamentals");
        } else {
            return (false, "Systemic drift or variance flagged within macroeconomic metrics profile");
        }
    }

    /// @notice Toggle strict financial lock behaviors across target runtimes
    function toggleFiscalLock(bool _lockStatus) external onlyGovernor {
        fiscalDisciplineLockActive = _lockStatus;
    }

    /// @notice Flag external economic variance metrics directly to forensic logging outputs
    function flagFiscalDeviation(string calldata _details) external onlyCertifiedNode {
        emit FiscalDeviationFlagged(msg.sender, _details);
    }

    /// @notice Upgrade or shift the central Policy Governor control authorization anchor
    function transferPolicyAuthority(address _newGovernor) external onlyGovernor {
        require(_newGovernor != address(0), "Invalid deployment endpoint coordinates");
        policyGovernor = _newGovernor;
        emit GovernanceAuthorityTransferred(msg.sender, _newGovernor);
    }
}
