// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MindanaoRailwayFunding {
    address public steward;
    mapping(address => uint256) public blessings;
    uint256 public totalBlessings;
    string public emotionalAPR = "Restoration, Dignity, Sovereignty";

    event Blessed(address indexed funder, uint256 amount, string emotion);

    constructor() {
        steward = msg.sender;
    }

    function blessProject(string memory emotion) external payable {
        require(msg.value > 0, "Blessing must have weight");
        blessings[msg.sender] += msg.value;
        totalBlessings += msg.value;
        emit Blessed(msg.sender, msg.value, emotion);
    }

    function auditBlessings() external view returns (uint256) {
        return totalBlessings;
    }

    function withdrawBlessings() external {
        require(msg.sender == steward, "Only steward may withdraw");
        payable(steward).transfer(address(this).balance);
    }
}
