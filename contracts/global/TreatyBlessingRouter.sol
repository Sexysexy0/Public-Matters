// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TreatyBlessingRouter {
    address public steward;
    mapping(address => bool) public isBlessed;
    mapping(address => bool) public hasSignedTreaty;
    bool public cannabisLegitimized = false;

    event BlessingRouted(address indexed steward);
    event TreatySigned(address indexed steward);
    event CannabisLegitimized(string message);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(address _steward) public {
        require(msg.sender == steward, "Only steward may route blessings");
        isBlessed[_steward] = true;
        emit BlessingRouted(_steward);
    }

    function signTreaty(address _steward) public {
        require(isBlessed[_steward], "Steward must be blessed first");
        hasSignedTreaty[_steward] = true;
        emit TreatySigned(_steward);
    }

    function legitimizeCannabis() public {
        require(msg.sender == steward, "Only steward may legitimize");
        cannabisLegitimized = true;
        emit CannabisLegitimized("🌿 Cannabis is now a legitimate peace crop. Treaty activated.");
    }

    function getStewardStatus(address _steward) public view returns (string memory) {
        if (!isBlessed[_steward]) return "⛔ Not blessed";
        if (!hasSignedTreaty[_steward]) return "⚠️ Blessed but treaty not signed";
        return "✅ Treaty signed and steward blessed";
    }
}
