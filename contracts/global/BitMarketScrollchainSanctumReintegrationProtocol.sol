// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainSanctumReintegrationProtocol {
    address public steward;
    mapping(string => bool) public reintegratedTalent;
    mapping(string => uint256) public aprRestorationScore;

    event TalentReintegrated(string name, string sector, uint256 aprScore, uint timestamp);

    function reintegrateTalent(string memory name, string memory sector, uint256 aprScore) public {
        reintegratedTalent[name] = true;
        aprRestorationScore[name] = aprScore;
        emit TalentReintegrated(name, sector, aprScore, block.timestamp);
    }

    function isReintegrated(string memory name) public view returns (bool) {
        return reintegratedTalent[name];
    }

    function getAPRScore(string memory name) public view returns (uint256) {
        return aprRestorationScore[name];
    }
}
