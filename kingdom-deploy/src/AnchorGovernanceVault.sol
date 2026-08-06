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

    // Set the addresses of all core contracts
    function setCoreContracts(
        address _registry,
        address _vault,
        address _treatyBase,
        address _escrow,
        address _arbitration
    ) external onlyOwner {
        registry = _registry;
        vault = _vault;
        treatyBase = _treatyBase;
        escrow = _escrow;
        arbitration = _arbitration;

        emit ContractUpdated("Registry", _registry);
        emit ContractUpdated("Vault", _vault);
        emit ContractUpdated("TreatyBase", _treatyBase);
        emit ContractUpdated("Escrow", _escrow);
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

    // Example: get the full ecosystem status in one call
    function getSystemStatus() external view returns (
        address _registry,
        address _vault,
        address _treatyBase,
        address _escrow,
        address _arbitration,
        bool _paused
    ) {
        return (registry, vault, treatyBase, escrow, arbitration, isPaused);
    }
}
