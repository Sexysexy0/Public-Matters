// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Innovation Safety Covenant
 * Purpose: Ensure new technologies pass safety checks before deployment
 * Effect: Blocks unsafe or weaponized innovations
 * Safeguard: Governance-controlled approval and safety oracle validation
 */

contract InnovationSafetyCovenant {
    address public governanceBody;

    struct Innovation {
        string name;
        bool approved;
        bool safe;
    }

    mapping(uint256 => Innovation) public innovations;
    uint256 public innovationCount;

    event InnovationSubmitted(uint256 indexed id, string name);
    event InnovationReviewed(uint256 indexed id, bool approved, bool safe);

    modifier onlyGovernance() {
        require(msg.sender == governanceBody, "Not authorized");
        _;
    }

    constructor() {
        governanceBody = msg.sender;
    }

    function submitInnovation(string calldata name) external onlyGovernance {
        innovationCount++;
        innovations[innovationCount] = Innovation(name, false, false);
        emit InnovationSubmitted(innovationCount, name);
    }

    function reviewInnovation(uint256 id, bool approved, bool safe) external onlyGovernance {
        require(id <= innovationCount, "Invalid innovation ID");
        innovations[id].approved = approved;
        innovations[id].safe = safe;
        emit InnovationReviewed(id, approved, safe);
    }

    function isDeployable(uint256 id) external view returns (bool) {
        Innovation memory i = innovations[id];
        return i.approved && i.safe;
    }
}
