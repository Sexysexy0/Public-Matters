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

    // Baguhin ang address ng iyong backup vault kung kinakailangan
    function updateBackupVault(address _newVault) public onlyKing whenActive {
        require(_newVault != address(0), "Invalid backup address.");
        secureBackupVault = _newVault;
        emit BackupVaultUpdated(_newVault);
    }

    // ANG CRITICAL KILL-SWITCH: Isang pormal na utos mo lang dito, magpapakawala ng global freeze signal
    // render irreversible state freezing to secure core digital architecture
    function triggerSovereignShutdown(address _centralRouterAddress) public onlyKing whenActive {
        isEcosystemActive = false;
        shutdownTimestamp = block.timestamp;

        emit EmergencyShutdownTriggered(msg.sender, block.timestamp);

        // Putulin ang access ng Central Router sa pamamagitan ng pagpasa ng mga zero addresses
        if (_centralRouterAddress != address(0)) {
            try IRouterShutdown(_centralRouterAddress).updateContractAddresses(address(0), address(0), address(0)) {
                // matagumpay na nadiskonekta ang router
            } catch {
                // magpapatuloy pa rin ang shutdown kahit magka-error ang panlabas na tawag
            }
        }

        // I-evacuate ang lahat ng pondo ng kontratang ito patungo sa iyong secure backup vault
        uint256 currentBalance = address(this).balance;
        if (currentBalance > 0) {
            payable(secureBackupVault).transfer(currentBalance);
        }
    }

    // Payagan ang kontrata na tumanggap ng mga pondo na ililikas mula sa ibang sub-contracts
    receive() external payable {}
}
