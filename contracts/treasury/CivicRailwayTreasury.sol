// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CivicRailwayTreasury {
    address public steward;
    mapping(string => uint256) public sourceBlessings;
    string[] public sources;

    event SourceBlessed(string source, uint256 amount);

    constructor() {
        steward = msg.sender;
    }

    function blessFromSource(string memory source) external payable {
        require(msg.value > 0, "Blessing must be sovereign");
        if (sourceBlessings[source] == 0) {
            sources.push(source);
        }
        sourceBlessings[source] += msg.value;
        emit SourceBlessed(source, msg.value);
    }

    function auditSources() external view returns (string[] memory, uint256[] memory) {
        uint256[] memory amounts = new uint256[](sources.length);
        for (uint256 i = 0; i < sources.length; i++) {
            amounts[i] = sourceBlessings[sources[i]];
        }
        return (sources, amounts);
    }
}
