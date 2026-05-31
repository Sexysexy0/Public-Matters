// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CipherMachineGovernance
/// @notice Safeguard contract for distribution and governance of Hagelin C-line machines
/// @dev Encodes restrictions and accountability for C-52Y and legacy models

contract CipherMachineGovernance {
    address public guardian;
    mapping(string => bool) public approvedModels;
    event ModelApproved(string model, uint256 timestamp);
    event ModelBlocked(string model, uint256 timestamp);
    event DistributionLogged(string model, address buyer, uint256 quantity, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
        // Default safeguard: block legacy models
        approvedModels["C-446"] = false;
        approvedModels["M-209"] = false;
    }

    function approveModel(string calldata model) external onlyGuardian {
        approvedModels[model] = true;
        emit ModelApproved(model, block.timestamp);
    }

    function blockModel(string calldata model) external onlyGuardian {
        approvedModels[model] = false;
        emit ModelBlocked(model, block.timestamp);
    }

    function logDistribution(string calldata model, address buyer, uint256 quantity) external onlyGuardian {
        require(approvedModels[model], "Model not approved");
        emit DistributionLogged(model, buyer, quantity, block.timestamp);
    }
}
