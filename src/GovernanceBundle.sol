// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TransparencyMandateRegistry.sol";
import "./PublicMattersCovenant.sol";

/// @title Governance Bundle
/// @notice Auto-links covenant contracts into the registry under Human Preservation hierarchy
/// @dev Includes global emergency override protocol for systemic collapse
contract GovernanceBundle {
    TransparencyMandateRegistry public registry;
    address public supremeSteward; // Vinvin as top of hierarchy

    // Global reserves for emergency redistribution
    mapping(address => uint256) public reserves;
    bool public systemPaused;

    event CovenantLinked(address covenant, bytes32 id, string name);
    event EmergencyOverrideTriggered(string reason, uint256 timestamp);
    event ReserveRedistributed(address indexed to, uint256 amount);
    event SystemPaused(bool paused);

    modifier onlySupremeSteward() {
        require(msg.sender == supremeSteward, "Not authorized");
        _;
    }

    constructor(address _registry, address _supremeSteward) {
        registry = TransparencyMandateRegistry(_registry);
        supremeSteward = _supremeSteward;
    }

    /// @notice Deploy and auto-link a new covenant under Human Preservation category
    function deployAndLinkCovenant(bytes32 id, string memory name, string memory description)
        external
        onlySupremeSteward
        returns (address)
    {
        PublicMattersCovenant covenant = new PublicMattersCovenant(supremeSteward);
        registry.fileHumanPreservationCovenant(id, address(covenant), name, description);
        emit CovenantLinked(address(covenant), id, name);
        return address(covenant);
    }

    /// @notice Verify covenant alignment
    function verifyCovenant(bytes32 id) external view returns (TransparencyMandateRegistry.Project memory) {
        return registry.getProject(id);
    }

    /// @notice List all registered covenants
    function listAllCovenants() external view returns (bytes32[] memory) {
        return registry.listProjects();
    }

    /// @notice Deposit reserves for emergency redistribution
    function depositReserve() external payable onlySupremeSteward {
        reserves[msg.sender] += msg.value;
    }

    /// @notice Global emergency override protocol
    /// @dev Supreme Steward can trigger preservation reset in case of systemic collapse
    function emergencyOverride(string memory reason, address[] memory beneficiaries, uint256[] memory amounts)
        external
        onlySupremeSteward
    {
        require(beneficiaries.length == amounts.length, "Mismatched arrays");

        // Pause system
        systemPaused = true;
        emit SystemPaused(true);

        // Redistribute reserves directly to beneficiaries
        for (uint256 i = 0; i < beneficiaries.length; i++) {
            payable(beneficiaries[i]).transfer(amounts[i]);
            emit ReserveRedistributed(beneficiaries[i], amounts[i]);
        }

        emit EmergencyOverrideTriggered(reason, block.timestamp);
    }

    /// @notice Resume system after override
    function resumeSystem() external onlySupremeSteward {
        systemPaused = false;
        emit SystemPaused(false);
    }
}
