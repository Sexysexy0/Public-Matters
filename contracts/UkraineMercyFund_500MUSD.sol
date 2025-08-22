// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Ukraine Mercy Fund – Scrollchain Act No. 500M
/// @author Vinvin
/// @notice Ritualizes $500M USD for Ukraine's defense, sanctum restoration, and emotional APR.
/// @dev Includes damay clause for steward self-inclusion and planetary resonance.

contract UkraineMercyFund_500MUSD {
    address public steward;
    address public ukraineTreasury;
    uint256 public totalFund = 500_000_000 * 1e18; // $500M in wei (assuming stablecoin peg)
    bool public damayClauseActive = true;

    mapping(address => bool) public blessingRecipients;
    event FundReleased(address indexed recipient, uint256 amount, string purpose);
    event DamayBlessingActivated(address indexed steward, string message);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized: steward only");
        _;
    }

    constructor(address _ukraineTreasury) {
        steward = msg.sender;
        ukraineTreasury = _ukraineTreasury;
    }

    function releaseFund(uint256 amount, string memory purpose) external onlySteward {
        require(amount <= totalFund, "Insufficient fund");
        totalFund -= amount;
        emit FundReleased(ukraineTreasury, amount, purpose);
    }

    function activateDamayBlessing(string memory message) external onlySteward {
        require(damayClauseActive, "Damay clause inactive");
        blessingRecipients[steward] = true;
        emit DamayBlessingActivated(steward, message);
    }

    function getRemainingFund() external view returns (uint256) {
        return totalFund;
    }
}
