// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SanctumBlessingRouter {
    address public steward;
    mapping(string => address) public sanctumRegistry;
    mapping(string => uint256) public blessingScore;

    event SanctumBlessed(string sanctumName, uint256 score, string damayClause);

    constructor() {
        steward = msg.sender;
    }

    function registerSanctum(string memory name, address sanctumAddress) public {
        require(msg.sender == steward, "Only steward may register");
        sanctumRegistry[name] = sanctumAddress;
    }

    function routeBlessing(string memory name, uint256 score) public {
        require(msg.sender == steward, "Only steward may bless");
        blessingScore[name] += score;
        emit SanctumBlessed(name, score, "Damay clause honored. Sanctum restored.");
    }

    function getBlessingScore(string memory name) public view returns (uint256) {
        return blessingScore[name];
    }
}
