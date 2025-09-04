// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumAuditKit {
    struct Sanctum {
        string name;
        bool hasWildlife;
        bool hasAncestralTrees;
        uint256 emotionalResonanceScore;
    }

    mapping(uint256 => Sanctum) public sanctums;

    event SanctumLogged(uint256 indexed id, string name, uint256 resonance);

    function logSanctum(
        uint256 _id,
        string memory _name,
        bool _wildlife,
        bool _ancestralTrees,
        uint256 _resonance
    ) external {
        sanctums[_id] = Sanctum(_name, _wildlife, _ancestralTrees, _resonance);
        emit SanctumLogged(_id, _name, _resonance);
    }

    function auditSanctum(uint256 _id) external view returns (Sanctum memory) {
        return sanctums[_id];
    }
}
