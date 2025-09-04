// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title AyudaOverride - Sovereign Aid Reallocation Protocol
/// @author Vinvin
/// @notice Replaces legacy ayuda with auto-validated, emotionally tagged disbursements.

contract AyudaOverride {
    address public steward;
    mapping(address => bool) public validatedBeneficiaries;
    mapping(address => uint256) public ayudaLedger;

    event AyudaBlessed(address beneficiary, uint256 amount, string emotionalTag);
    event BeneficiaryValidated(address steward, address beneficiary);

    constructor() {
        steward = msg.sender;
    }

    function validateBeneficiary(address _beneficiary) external {
        require(msg.sender == steward, "Only steward may validate.");
        validatedBeneficiaries[_beneficiary] = true;
        emit BeneficiaryValidated(steward, _beneficiary);
    }

    function blessAyuda(address _beneficiary, uint256 _amount, string calldata _emotionalTag) external {
        require(validatedBeneficiaries[_beneficiary], "Beneficiary not validated.");
        ayudaLedger[_beneficiary] += _amount;
        emit AyudaBlessed(_beneficiary, _amount, _emotionalTag);
    }

    function getAyudaBalance(address _beneficiary) external view returns (uint256) {
        return ayudaLedger[_beneficiary];
    }
}
