// SPDX-License-Identifier: MIT
// Contract Name: RepeatOffenderCovenant
// Purpose: Encode safeguards for handling repeat offenders
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract RepeatOffenderCovenant {
    address public chiefOperator;
    uint256 public offenderCount;

    struct Offender {
        string name;            // placeholder for offender identity
        string offense;         // e.g., retail theft, resisting arrest
        string safeguard;       // e.g., rehabilitation program, stricter containment, restorative justice
        uint256 timestamp;
    }

    Offender[] public offenders;

    event OffenderAdded(string name, string offense, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        offenderCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new offender covenant
    function addOffender(string memory name, string memory offense, string memory safeguard) public onlyChief {
        offenders.push(Offender(name, offense, safeguard, block.timestamp));
        offenderCount++;
        emit OffenderAdded(name, offense, safeguard, block.timestamp);
    }

    // View offender details
    function getOffender(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < offenders.length, "Invalid offender index");
        Offender memory o = offenders[index];
        return (o.name, o.offense, o.safeguard, o.timestamp);
    }
}
