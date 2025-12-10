// contracts/CivicGuardian.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CivicGuardian
 * @notice Guardianship protocols for public health, housing, transport, and asset equity.
 */
contract CivicGuardian {
    address public admin;

    enum GuardianType { Health, Housing, Transport, Asset }

    struct Guardian {
        address wallet;
        GuardianType gtype;
        string region;     // e.g., "Bulacan", "NCR"
        bool active;
    }

    struct ActionLog {
        address guardian;
        GuardianType gtype;
        string region;
        string action;     // e.g., "Inspection", "Allocation", "Reroute", "Audit"
        string report;     // summary/details
        uint256 timestamp;
    }

    Guardian[] public guardians;
    ActionLog[] public logs;
    mapping(address => bool) public isGuardian;

    event GuardianRegistered(address indexed wallet, GuardianType gtype, string region, bool active);
    event GuardianStatusUpdated(address indexed wallet, bool active);
    event ActionLogged(address indexed guardian, GuardianType gtype, string region, string action, string report, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerGuardian(address wallet, GuardianType gtype, string calldata region, bool active) external onlyAdmin {
        require(!isGuardian[wallet], "Already guardian");
        guardians.push(Guardian(wallet, gtype, region, active));
        isGuardian[wallet] = true;
        emit GuardianRegistered(wallet, gtype, region, active);
    }

    function setGuardianActive(address wallet, bool active) external onlyAdmin {
        require(isGuardian[wallet], "Not guardian");
        for (uint256 i = 0; i < guardians.length; i++) {
            if (guardians[i].wallet == wallet) {
                guardians[i].active = active;
                emit GuardianStatusUpdated(wallet, active);
                break;
            }
        }
    }

    function logAction(GuardianType gtype, string calldata region, string calldata action, string calldata report) external {
        require(isGuardian[msg.sender], "Only guardians");
        logs.push(ActionLog(msg.sender, gtype, region, action, report, block.timestamp));
        emit ActionLogged(msg.sender, gtype, region, action, report, block.timestamp);
    }

    function totalGuardians() external view returns (uint256) {
        return guardians.length;
    }

    function totalLogs() external view returns (uint256) {
        return logs.length;
    }

    function getGuardian(uint256 id) external view returns (Guardian memory) {
        require(id < guardians.length, "Invalid id");
        return guardians[id];
    }

    function getLog(uint256 id) external view returns (ActionLog memory) {
        require(id < logs.length, "Invalid id");
        return logs[id];
    }
}
