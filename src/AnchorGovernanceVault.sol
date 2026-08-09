// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AnchorGovernanceVault
 * @dev Central registry and emergency pause for the entire ecosystem
 */
contract AnchorGovernanceVault {
    address public immutable owner;

    // Core contract addresses
    address public registry;
    address public vault;
    address public treatyBase;
    address public escrow;
    address public whistleblowerVault;
    address public sovereignCovenant;
    address public cyberResilience;
    address public arbitration;

    bool public isPaused;

    event ContractUpdated(string indexed name, address newAddress);
    event SystemPaused(address indexed by);
    event SystemUnpaused(address indexed by);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner");
        _;
    }

    modifier whenNotPaused() {
        require(!isPaused, "System is paused");
        _;
    }

    constructor() {
        owner = msg.sender;
        isPaused = false;
    }

    // Set the addresses of all core contracts (Updated to include 3 new sovereign bricks)
    function setCoreContracts(
        address _registry,
        address _vault,
        address _treatyBase,
        address _escrow,
        address _whistleblower,
        address _covenant,
        address _cyber,
        address _arbitration
    ) external onlyOwner {
        registry = _registry;
        vault = _vault;
        treatyBase = _treatyBase;
        escrow = _escrow;
        whistleblowerVault = _whistleblower;
        sovereignCovenant = _covenant;
        cyberResilience = _cyber;
        arbitration = _arbitration;

        emit ContractUpdated("Registry", _registry);
        emit ContractUpdated("Vault", _vault);
        emit ContractUpdated("TreatyBase", _treatyBase);
        emit ContractUpdated("Escrow", _escrow);
        emit ContractUpdated("Whistleblower", _whistleblower);
        emit ContractUpdated("Covenant", _covenant);
        emit ContractUpdated("CyberResilience", _cyber);
        emit ContractUpdated("Arbitration", _arbitration);
    }

    // Emergency pause - stops all operations in dependent contracts
    function pause() external onlyOwner {
        isPaused = true;
        emit SystemPaused(msg.sender);
    }

    function unpause() external onlyOwner {
        isPaused = false;
        emit SystemUnpaused(msg.sender);
    }

    // Get the full ecosystem status
    function getSystemStatus() external view returns (
        address _registry,
        address _vault,
        address _treatyBase,
        address _escrow,
        address _whistleblower,
        address _covenant,
        address _cyber,
        address _arbitration,
        bool _paused
    ) {
        return (
            registry,
            vault,
            treatyBase,
            escrow,
            whistleblowerVault,
            sovereignCovenant,
            cyberResilience,
            arbitration,
            isPaused
        );
    }
}
