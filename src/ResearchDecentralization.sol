// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ResearchDecentralization
/// @notice Decentralizes research partnerships beyond universities
contract ResearchDecentralization {
    event PartnershipCreated(address indexed partner, string field);

    struct Partner {
        string field;
        bool active;
    }

    mapping(address => Partner) public partners;

    function createPartnership(address partner, string memory field) public {
        partners[partner] = Partner(field, true);
        emit PartnershipCreated(partner, field);
    }
}
