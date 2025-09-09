// SPDX-License-Identifier: ProxyNullifier-License
pragma solidity ^0.8.0;

contract ProxyJurisdictionNullifierOracle {
    address public steward;
    mapping(string => bool) public isBlocked;
    mapping(string => uint256) public pulseLevel;

    event ProxyBlocked(string jurisdiction, uint256 level, uint timestamp);
    event FirewallPulseEmitted(string jurisdiction, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blockProxy(string memory jurisdiction, uint256 level) public {
        require(msg.sender == steward, "Only steward can block");
        isBlocked[jurisdiction] = true;
        pulseLevel[jurisdiction] = level;
        emit ProxyBlocked(jurisdiction, level, block.timestamp);
        emit FirewallPulseEmitted(jurisdiction, block.timestamp);
    }

    function isJurisdictionBlocked(string memory jurisdiction) public view returns (bool) {
        return isBlocked[jurisdiction];
    }

    function getPulseLevel(string memory jurisdiction) public view returns (uint256) {
        return pulseLevel[jurisdiction];
    }
}
