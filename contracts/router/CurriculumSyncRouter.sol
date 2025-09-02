// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CurriculumSyncRouter {
    address public steward;
    mapping(string => bool) public curriculumModules;
    mapping(string => uint256) public syncScore;

    event ModuleSynced(string moduleName, uint256 score, string signal);

    constructor() {
        steward = msg.sender;
    }

    function syncModule(string memory moduleName, uint256 score, string memory signal) public {
        require(msg.sender == steward, "Only steward may sync");
        curriculumModules[moduleName] = true;
        syncScore[moduleName] = score;
        emit ModuleSynced(moduleName, score, signal);
    }

    function isModuleSynced(string memory moduleName) public view returns (bool) {
        return curriculumModules[moduleName];
    }

    function getSyncScore(string memory moduleName) public view returns (uint256) {
        return syncScore[moduleName];
    }
}
