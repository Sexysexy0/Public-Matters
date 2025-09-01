// SPDX-License-Identifier: MPL-1.0
pragma solidity ^0.8.21;

/// @title VaultDesignationAudit
/// @notice Detects rerouting of excess funds into private-access vaults and logs budgetary cash shifts
contract VaultDesignationAudit {
    event VaultDesignation(string vaultName, uint256 amount, address designatedBy, uint256 timestamp);
    event BudgetaryCashShift(uint256 amount, string reason, uint256 timestamp);
    event EmotionalTelemetry(uint256 griefIndex, uint256 trustDrop, uint256 timestamp);

    struct Vault {
        string name;
        uint256 total;
        address designatedBy;
    }

    Vault[] public vaults;

    function designateVault(string calldata name, uint256 amount) external {
        vaults.push(Vault(name, amount, msg.sender));
        emit VaultDesignation(name, amount, msg.sender, block.timestamp);
    }

    function logCashShift(uint256 amount, string calldata reason) external {
        emit BudgetaryCashShift(amount, reason, block.timestamp);
    }

    function logEmotionalTelemetry(uint256 griefIndex, uint256 trustDrop) external {
        emit EmotionalTelemetry(griefIndex, trustDrop, block.timestamp);
    }

    function latestVault() external view returns (string memory name, uint256 total, address designatedBy) {
        Vault memory v = vaults[vaults.length - 1];
        return (v.name, v.total, v.designatedBy);
    }
}
