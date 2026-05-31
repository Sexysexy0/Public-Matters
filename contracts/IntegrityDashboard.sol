// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntegrityDashboard
/// @notice Aggregates logs and governance states into a unified dashboard
/// @dev Connects WaterJusticeLedger, CipherMachineGovernance, CryptoSuccession, and IntegrityOracle

interface IWaterJusticeLedger {
    function getRecord(uint256 id) external view returns (string memory action, string memory details);
}

interface ICipherMachineGovernance {
    function approvedModels(string calldata model) external view returns (bool);
}

interface ICryptoSuccession {
    function isTransitionComplete() external view returns (bool);
}

interface IIntegrityOracle {
    function feedData(string calldata source, string calldata data) external;
}

contract IntegrityDashboard {
    address public guardian;
    IWaterJusticeLedger public ledger;
    ICipherMachineGovernance public cipherGov;
    ICryptoSuccession public succession;
    IIntegrityOracle public oracle;

    event DashboardQueried(address indexed querier, string section, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(
        address _guardian,
        address _ledger,
        address _cipherGov,
        address _succession,
        address _oracle
    ) {
        guardian = _guardian;
        ledger = IWaterJusticeLedger(_ledger);
        cipherGov = ICipherMachineGovernance(_cipherGov);
        succession = ICryptoSuccession(_succession);
        oracle = IIntegrityOracle(_oracle);
    }

    /// @notice Query water justice record
    function queryWaterRecord(uint256 id) external onlyGuardian returns (string memory action, string memory details) {
        emit DashboardQueried(msg.sender, "WaterJusticeLedger", block.timestamp);
        return ledger.getRecord(id);
    }

    /// @notice Check if cipher model is approved
    function checkCipherModel(string calldata model) external onlyGuardian returns (bool) {
        emit DashboardQueried(msg.sender, "CipherMachineGovernance", block.timestamp);
        return cipherGov.approvedModels(model);
    }

    /// @notice Check if succession is complete
    function checkSuccessionStatus() external onlyGuardian returns (bool) {
        emit DashboardQueried(msg.sender, "CryptoSuccession", block.timestamp);
        return succession.isTransitionComplete();
    }

    /// @notice Feed oracle data into dashboard
    function feedOracle(string calldata source, string calldata data) external onlyGuardian {
        oracle.feedData(source, data);
        emit DashboardQueried(msg.sender, "IntegrityOracle", block.timestamp);
    }
}
