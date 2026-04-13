// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IGuard { function isSystemInCrisis() external view returns (bool); }

contract TransparentRelief {
    IGuard public guard;
    address public commander;

    mapping(address => bool) public verifiedBeneficiaries;

    constructor(address _guard) {
        guard = IGuard(_guard);
        commander = msg.sender;
    }

    function distributeRelief() external payable {
        require(guard.isSystemInCrisis(), "Inflation below threshold. Normal Ops.");
        // Logic for direct distribution to verified wallets
    }

    function addBeneficiary(address _account) external {
        require(msg.sender == commander, "Only Commander adds targets.");
        verifiedBeneficiaries[_account] = true;
    }
}
