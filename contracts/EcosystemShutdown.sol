// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IRouterShutdown {
    function updateContractAddresses(address _reputation, address _gracePeriod, address _auditHistory) external;
}

contract EcosystemShutdown {
    address public sovereignKing;
    address public secureBackupVault;
    bool public isEcosystemActive;
    uint256 public shutdownTimestamp;

    event EmergencyShutdownTriggered(address indexed initiatedBy, uint256 timestamp);
    event BackupVaultUpdated(address indexed newVault);

    modifier onlyKing() {
        require(msg.sender == sovereignKing, "Error: Sovereign denial. Only the King can pull the lever.");
        _;
    }

    modifier whenActive() {
        require(isEcosystemActive, "Error: System breach protocol active. Ecosystem is already frozen permanently.");
        _;
    }

    constructor(address _secureBackupVault) {
        sovereignKing = msg.sender;
        secureBackupVault = _secureBackupVault;
        isEcosystemActive = true;
    }

    function updateBackupVault(address _newVault) public onlyKing whenActive {
        require(_newVault != address(0), "Invalid backup address.");
        secureBackupVault = _newVault;
        emit BackupVaultUpdated(_newVault);
    }

    function triggerSovereignShutdown(address _centralRouterAddress) public onlyKing whenActive {
        isEcosystemActive = false;
        shutdownTimestamp = block.timestamp;
        emit EmergencyShutdownTriggered(msg.sender, block.timestamp);

        if (_centralRouterAddress != address(0)) {
            try IRouterShutdown(_centralRouterAddress).updateContractAddresses(address(0), address(0), address(0)) {
            } catch {}
        }

        uint256 currentBalance = address(this).balance;
        if (currentBalance > 0) {
            (bool success, ) = payable(secureBackupVault).call{value: currentBalance}("");
            require(success, "Transfer failed");
        }
    }

    receive() external payable {}
}
