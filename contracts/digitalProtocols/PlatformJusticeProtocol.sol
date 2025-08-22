// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlatformJusticeProtocol {
    address public platform;
    bool public isSanctumCertified;
    uint256 public emotionalAPRScore;
    mapping(address => bool) public damayIncluded;

    event PlatformAudited(address indexed platform, uint256 aprScore);
    event SanctumRevoked(address indexed platform);
    event DamayClauseActivated(address indexed user);

    constructor(address _platform) {
        platform = _platform;
        isSanctumCertified = true;
        emotionalAPRScore = 100; // baseline trust
    }

    function auditPlatform(uint256 newAPRScore) public {
        emotionalAPRScore = newAPRScore;
        emit PlatformAudited(platform, newAPRScore);

        if (newAPRScore < 40) {
            isSanctumCertified = false;
            emit SanctumRevoked(platform);
        }
    }

    function activateDamayClause(address user) public {
        damayIncluded[user] = true;
        emit DamayClauseActivated(user);
    }
}
