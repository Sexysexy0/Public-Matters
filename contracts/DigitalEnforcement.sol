// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DigitalEnforcement
/// @notice Automates enforcement of tax compliance and prevents under-the-table deals
contract DigitalEnforcement {
    address public oversightCommittee;
    mapping(address => bool) public registeredTaxpayers;
    mapping(address => bool) public flaggedEntities;

    event TaxpayerRegistered(address indexed taxpayer);
    event EntityFlagged(address indexed entity, string reason);
    event EnforcementExecuted(address indexed entity, string action);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Register taxpayers digitally
    function registerTaxpayer(address taxpayer) external onlyOversight {
        registeredTaxpayers[taxpayer] = true;
        emit TaxpayerRegistered(taxpayer);
    }

    /// @notice Flag suspicious entities for corruption or evasion
    function flagEntity(address entity, string calldata reason) external onlyOversight {
        flaggedEntities[entity] = true;
        emit EntityFlagged(entity, reason);
    }

    /// @notice Execute enforcement actions (e.g., freeze, audit)
    function enforceAction(address entity, string calldata action) external onlyOversight {
        require(flaggedEntities[entity], "Entity not flagged");
        emit EnforcementExecuted(entity, action);
    }
}
