// SPDX-License-Identifier: MIT
// Contract Name: MaterialismFilterProtocol
// Purpose: Safeguard against excessive obsession with wealth/status
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MaterialismFilterProtocol {
    address public chiefOperator;
    uint256 public filterCount;

    struct Filter {
        string trigger;
        string correctiveAction;
        uint256 timestamp;
    }

    Filter[] public filters;

    event FilterApplied(string trigger, string correctiveAction, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        filterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Apply new materialism filter
    function applyFilter(string memory trigger, string memory correctiveAction) public onlyChief {
        filters.push(Filter(trigger, correctiveAction, block.timestamp));
        filterCount++;
        emit FilterApplied(trigger, correctiveAction, block.timestamp);
    }

    // View filter details
    function getFilter(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < filters.length, "Invalid filter index");
        Filter memory f = filters[index];
        return (f.trigger, f.correctiveAction, f.timestamp);
    }
}
