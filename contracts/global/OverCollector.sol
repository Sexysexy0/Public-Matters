// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title OverCollector
/// @notice Collects surplus funds from overfunded departments for sovereign reallocation
contract OverCollector {
    address public steward;
    mapping(address => uint256) public surplusLedger;
    event SurplusCollected(address indexed department, uint256 amount);
    event StewardBlessed(address indexed steward);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
        emit StewardBlessed(steward);
    }

    /// @notice Departments send surplus ETH here
    function collectSurplus() external payable {
        require(msg.value > 0, "No surplus sent");
        surplusLedger[msg.sender] += msg.value;
        emit SurplusCollected(msg.sender, msg.value);
    }

    /// @notice View total collected surplus
    function totalSurplus() external view returns (uint256) {
        return address(this).balance;
    }
}
