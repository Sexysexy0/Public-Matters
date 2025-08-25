// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignalAccessSanctum {
    address public DICT;
    mapping(string => bool) public essentialApps;
    mapping(address => bool) public exemptTelcos;

    event AppWhitelisted(string appName);
    event TelcoExempted(address telco);
    event FreeAccessGranted(address user, string appName);

    constructor() {
        DICT = msg.sender;
    }

    function whitelistApp(string memory appName) external {
        require(msg.sender == DICT, "Only DICT can whitelist");
        essentialApps[appName] = true;
        emit AppWhitelisted(appName);
    }

    function exemptTelco(address telco) external {
        require(msg.sender == DICT, "Only DICT can exempt");
        exemptTelcos[telco] = true;
        emit TelcoExempted(telco);
    }

    function grantFreeAccess(address user, string memory appName) external {
        require(essentialApps[appName], "App not whitelisted");
        require(exemptTelcos[msg.sender], "Telco not exempted");
        emit FreeAccessGranted(user, appName);
    }

    function isAppFree(string memory appName) external view returns (bool) {
        return essentialApps[appName];
    }
}
