// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title MercyDebtFund.sol
/// @dev Ritualizes sovereign debt relief for allied nations—based on emotional APR, crisis index, and planetary solidarity

contract MercyDebtFund {
    address public steward;

    struct DebtRelief {
        string country;
        uint256 reliefAmountUSD;
        uint256 emotionalAPR;
        string crisisIndex; // e.g., "Economic", "Post-conflict", "Climate"
        string lore;
        bool isForgiven;
    }

    mapping(bytes32 => DebtRelief) public reliefs;
    bytes32[] public reliefList;

    event ReliefLogged(bytes32 indexed reliefId, string country, uint256 reliefAmountUSD);
    event DebtForgiven(bytes32 indexed reliefId, string lore);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Log a debt relief entry
    function logRelief(
        bytes32 reliefId,
        string memory country,
        uint256 reliefAmountUSD,
        uint256 emotionalAPR,
        string memory crisisIndex,
        string memory lore
    ) public onlySteward {
        reliefs[reliefId] = DebtRelief({
            country: country,
            reliefAmountUSD: reliefAmountUSD,
            emotionalAPR: emotionalAPR,
            crisisIndex: crisisIndex,
            lore: lore,
            isForgiven: false
        });

        reliefList.push(reliefId);
        emit ReliefLogged(reliefId, country, reliefAmountUSD);
    }

    /// @notice Forgive debt if emotional APR is mythic
    function forgiveDebt(bytes32 reliefId) public onlySteward {
        require(reliefs[reliefId].emotionalAPR >= 850, "Mercy threshold not met");
        reliefs[reliefId].isForgiven = true;
        emit DebtForgiven(reliefId, reliefs[reliefId].lore);
    }

    /// @notice Retrieve relief metadata
    function getRelief(bytes32 reliefId) public view returns (DebtRelief memory) {
        return reliefs[reliefId];
    }

    /// @notice List all debt relief entries
    function listReliefs() public view returns (bytes32[] memory) {
        return reliefList;
    }
}
