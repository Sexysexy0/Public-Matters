// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Public Matters Covenant - Bill of Human Preservation
/// @notice Humanity first, Living things next, System last.
/// @dev System is defined as tool only, never priority.
contract PublicMattersCovenant {
    address public steward; // global guardian of covenant

    // Jurisdiction safeguard
    mapping(string => bool) public recognizedJurisdictions;

    event PreservationDeclared(string principle, address indexed by);
    event Redistribution(address indexed from, address indexed to, uint256 value, string assetType);
    event RestAcknowledged(address indexed human, string note);
    event JurisdictionAdded(string jurisdiction, address indexed by);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
        emit PreservationDeclared("Humanity First Principle", _steward);
        emit PreservationDeclared("Living Things Protection", _steward);
        emit PreservationDeclared("System as Tool, not Priority", _steward);
    }

    /// @notice Redistribute assets directly to humans or communities
    function redistribute(address to, uint256 value, string memory assetType) external onlySteward {
        emit Redistribution(msg.sender, to, value, assetType);
    }

    /// @notice Acknowledge rest as a right, not permission
    function acknowledgeRest(address human, string memory note) external onlySteward {
        emit RestAcknowledged(human, note);
    }

    /// @notice Declare covenant principle publicly
    function declarePrinciple(string memory principle) external onlySteward {
        emit PreservationDeclared(principle, msg.sender);
    }

    /// @notice Add global jurisdiction safeguard
    function addJurisdiction(string memory jurisdiction) external onlySteward {
        recognizedJurisdictions[jurisdiction] = true;
        emit JurisdictionAdded(jurisdiction, msg.sender);
    }

    /// @notice Verify if jurisdiction is aligned to covenant
    function isJurisdictionAligned(string memory jurisdiction) external view returns (bool) {
        return recognizedJurisdictions[jurisdiction];
    }
}
