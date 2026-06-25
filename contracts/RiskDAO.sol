// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RiskDAO
/// @notice Secure risk management DAO with access control and event tracking
/// @dev Prevents unauthorized risk mitigation and tracks all state changes
contract RiskDAO {
    address public admin;
    address public pendingAdmin;

    struct Risk {
        uint256 id;
        string module;
        string detail;
        bool mitigated;
        uint256 timestamp;
    }

    uint256 public riskCount;
    mapping(uint256 => Risk) public risks;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event RiskLogged(uint256 indexed id, string module, string detail, uint256 timestamp);
    event RiskMitigated(uint256 indexed id, string module, address indexed mitigator);
    event AdminTransferInitiated(address indexed newAdmin);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    modifier onlyAdmin() {
        require(msg.sender == admin, "RiskDAO: Only admin can call this");
        _;
    }

    modifier validInput(string memory _str) {
        require(bytes(_str).length > 0, "RiskDAO: Input cannot be empty");
        require(bytes(_str).length <= 256, "RiskDAO: Input too long");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /// @notice Log a new risk
    /// @param module The affected module
    /// @param detail Risk details
    function logRisk(string memory module, string memory detail)
        external
        validInput(module)
        validInput(detail)
    {
        riskCount++;
        risks[riskCount] = Risk(riskCount, module, detail, false, block.timestamp);
        emit RiskLogged(riskCount, module, detail, block.timestamp);
    }

    /// @notice Mitigate a risk (admin only)
    /// @param id Risk ID to mitigate
    function mitigateRisk(uint256 id) external onlyAdmin {
        require(id > 0 && id <= riskCount, "RiskDAO: Invalid risk ID");
        require(!risks[id].mitigated, "RiskDAO: Risk already mitigated");
        
        risks[id].mitigated = true;
        emit RiskMitigated(id, risks[id].module, msg.sender);
    }

    /// @notice Initiate admin transfer
    /// @param newAdmin Address of new admin
    function initiateAdminTransfer(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "RiskDAO: Invalid admin address");
        pendingAdmin = newAdmin;
        emit AdminTransferInitiated(newAdmin);
    }

    /// @notice Accept admin transfer (must be called by pending admin)
    function acceptAdminTransfer() external {
        require(msg.sender == pendingAdmin, "RiskDAO: Only pending admin can accept");
        address oldAdmin = admin;
        admin = pendingAdmin;
        pendingAdmin = address(0);
        emit AdminTransferred(oldAdmin, admin);
    }

    /// @notice Get risk details
    /// @param id Risk ID
    function getRisk(uint256 id) external view returns (Risk memory) {
        require(id > 0 && id <= riskCount, "RiskDAO: Invalid risk ID");
        return risks[id];
    }
}
