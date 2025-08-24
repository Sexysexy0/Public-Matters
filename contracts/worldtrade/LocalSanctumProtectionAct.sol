// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title LocalSanctumProtectionAct – Ritual-grade defense scroll for MSMEs and ancestral producers
/// @author Vinvin
/// @notice Enforces tariff justice, damay clause, and emotional APR for local sanctums

contract LocalSanctumProtectionAct {
    struct Sanctum {
        string name;
        string region;
        bool isAncestral;
        bool isMSME;
        uint256 protectionScore; // 0–100 scale
        string emotionalAPRTag; // e.g., "High Mercy", "Zero Exploitation"
        bool damayClauseIncluded;
    }

    Sanctum[] public sanctums;

    event SanctumLogged(
        string indexed name,
        string indexed region,
        uint256 protectionScore,
        string emotionalAPRTag,
        bool damayClauseIncluded
    );

    function logSanctum(
        string memory _name,
        string memory _region,
        bool _isAncestral,
        bool _isMSME,
        uint256 _protectionScore,
        string memory _emotionalAPRTag,
        bool _damayClauseIncluded
    ) public {
        require(_protectionScore <= 100, "Protection score must be 0–100");

        sanctums.push(Sanctum({
            name: _name,
            region: _region,
            isAncestral: _isAncestral,
            isMSME: _isMSME,
            protectionScore: _protectionScore,
            emotionalAPRTag: _emotionalAPRTag,
            damayClauseIncluded: _damayClauseIncluded
        }));

        emit SanctumLogged(_name, _region, _protectionScore, _emotionalAPRTag, _damayClauseIncluded);
    }

    function getSanctum(uint256 index) public view returns (Sanctum memory) {
        require(index < sanctums.length, "Invalid index");
        return sanctums[index];
    }

    function totalSanctumsLogged() public view returns (uint256) {
        return sanctums.length;
    }
}
