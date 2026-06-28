// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ParkingDisputeContract
/// @notice Covenant contract to log disputes and enforce penalties
contract ParkingDisputeContract {
    address public overseer;
    uint256 public offenseCount;

    struct Offense {
        uint256 id;
        address offender;
        string description;
        uint256 penaltyAmount;
        uint256 timestamp;
        bool resolved;
    }

    mapping(uint256 => Offense) public offenses;
    mapping(address => uint256) public balances;

    event OffenseReported(uint256 indexed id, address offender, string description);
    event PenaltyPaid(uint256 indexed id, address offender, uint256 amount);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function reportOffense(address _offender, string calldata _description, uint256 _penaltyAmount) external onlyOverseer {
        offenseCount++;
        offenses[offenseCount] = Offense({
            id: offenseCount,
            offender: _offender,
            description: _description,
            penaltyAmount: _penaltyAmount,
            timestamp: block.timestamp,
            resolved: false
        });
        emit OffenseReported(offenseCount, _offender, _description);
    }

    function payPenalty(uint256 _offenseId) external payable {
        Offense storage offense = offenses[_offenseId];
        require(msg.sender == offense.offender, "Only offender can pay");
        require(!offense.resolved, "Already resolved");
        require(msg.value == offense.penaltyAmount, "Incorrect penalty amount");

        balances[overseer] += msg.value;
        offense.resolved = true;

        emit PenaltyPaid(_offenseId, msg.sender, msg.value);
    }

    function withdraw() external onlyOverseer {
        uint256 amount = balances[overseer];
        balances[overseer] = 0;
        payable(overseer).transfer(amount);
    }
}
