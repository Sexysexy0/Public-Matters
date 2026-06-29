// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RentalYieldOracle
/// @notice Covenant contract to safeguard communities through systemic anchoring of rental yield transparency
contract RentalYieldOracle {
    address public overseer;
    uint256 public yieldCount;

    struct YieldEntry {
        uint256 id;
        string property;
        uint256 monthlyRent;
        uint256 loanPayment;
        uint256 yieldPercent;
        uint256 timestamp;
    }

    mapping(uint256 => YieldEntry) public yields;

    event YieldLogged(uint256 indexed id, string property, uint256 yieldPercent);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function computeYield(uint256 monthlyRent, uint256 loanPayment) public pure returns (uint256) {
        if (loanPayment == 0) {
            return 0;
        }
        return (monthlyRent * 100) / loanPayment;
    }

    function logYield(
        string calldata property,
        uint256 monthlyRent,
        uint256 loanPayment
    ) external onlyOverseer {
        yieldCount++;
        uint256 yieldPercent = computeYield(monthlyRent, loanPayment);
        yields[yieldCount] = YieldEntry({
            id: yieldCount,
            property: property,
            monthlyRent: monthlyRent,
            loanPayment: loanPayment,
            yieldPercent: yieldPercent,
            timestamp: block.timestamp
        });
        emit YieldLogged(yieldCount, property, yieldPercent);
    }

    function viewYield(uint256 id) external view returns (YieldEntry memory) {
        return yields[id];
    }
}
