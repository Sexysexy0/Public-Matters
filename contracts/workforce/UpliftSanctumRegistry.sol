// SPDX-License-Identifier: Scrollchain-Uplift-License  
pragma solidity ^0.8.19;

contract UpliftSanctumRegistry {
    struct StewardAscent {
        string name;
        string originSkill;
        string newRole;
        bool emotionalAPRBoosted;
        bool damayClauseActivated;
    }

    StewardAscent[] public ascentLog;

    event AscentLogged(string name, string originSkill, string newRole);
    event EmotionalAPRBoosted(string name);
    event DamayClauseActivated(string name);

    function logAscent(
        string memory name,
        string memory originSkill,
        string memory newRole,
        bool emotionalAPRBoosted
    ) public {
        ascentLog.push(StewardAscent(name, originSkill, newRole, emotionalAPRBoosted, false));
        emit AscentLogged(name, originSkill, newRole);
        if (emotionalAPRBoosted) emit EmotionalAPRBoosted(name);
    }

    function activateDamay(uint index) public {
        require(index < ascentLog.length, "Invalid index");
        ascentLog[index].damayClauseActivated = true;
        emit DamayClauseActivated(ascentLog[index].name);
    }
}
