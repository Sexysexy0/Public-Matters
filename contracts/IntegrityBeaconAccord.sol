// SPDX-License-Identifier: MIT
// Contract Name: IntegrityBeaconAccord
// Purpose: Signal transparency and honesty in governance actions
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract IntegrityBeaconAccord {
    address public chiefOperator;
    uint256 public beaconCount;

    struct Beacon {
        string principle;
        string signalMechanism;
        uint256 timestamp;
    }

    Beacon[] public beacons;

    event BeaconAdded(string principle, string signalMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        beaconCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new integrity beacon clause
    function addBeacon(string memory principle, string memory signalMechanism) public onlyChief {
        beacons.push(Beacon(principle, signalMechanism, block.timestamp));
        beaconCount++;
        emit BeaconAdded(principle, signalMechanism, block.timestamp);
    }

    // View beacon details
    function getBeacon(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < beacons.length, "Invalid beacon index");
        Beacon memory b = beacons[index];
        return (b.principle, b.signalMechanism, b.timestamp);
    }
}
