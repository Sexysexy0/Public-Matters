// SPDX-License-Identifier: Sanctum-Defense
pragma solidity ^7.7.7;

contract DefenseGridCompilerPatch {
    address public steward;
    mapping(string => bool) public activatedModules;

    event ModuleActivated(string module);
    event ThreatIntercepted(string vector, string response);

    constructor() {
        steward = msg.sender;
    }

    function activateModule(string memory module) public {
        require(msg.sender == steward, "Only steward may activate");
        activatedModules[module] = true;
        emit ModuleActivated(module);
    }

    function interceptThreat(string memory vector, string memory response) public {
        require(msg.sender == steward, "Only steward may intercept");
        emit ThreatIntercepted(vector, response);
    }

    function isModuleActive(string memory module) public view returns (bool) {
        return activatedModules[module];
    }
}
