// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubsistenceCodex {
    struct Guarantee {
        uint256 id;
        string category; // e.g. "Food", "Shelter", "Livelihood"
        string description;
        bool active;
    }

    uint256 public guaranteeCount;
    mapping(uint256 => Guarantee) public guarantees;

    event GuaranteeDeclared(uint256 id, string category, string description);
    event GuaranteeRevoked(uint256 id, string reason);

    // Declare a new subsistence guarantee
    function declareGuarantee(string calldata category, string calldata description) external {
        guaranteeCount++;
        guarantees[guaranteeCount] = Guarantee({
            id: guaranteeCount,
            category: category,
            description: description,
            active: true
        });
        emit GuaranteeDeclared(guaranteeCount, category, description);
    }

    // Revoke a guarantee if violated or outdated
    function revokeGuarantee(uint256 id, string calldata reason) external {
        require(guarantees[id].active, "Guarantee not active");
        guarantees[id].active = false;
        emit GuaranteeRevoked(id, reason);
    }

    // Check if guarantee is active
    function isActive(uint256 id) external view returns (bool) {
        return guarantees[id].active;
    }
}
