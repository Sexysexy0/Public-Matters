// contracts/HouseholdRelief.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HouseholdRelief
 * @notice Tracks household-level benefits from VAT reduction.
 */
contract HouseholdRelief {
    address public admin;

    struct Benefit {
        string category;   // "Food", "Medicine", "Utilities"
        uint256 savings;
        string note;
        uint256 timestamp;
    }

    Benefit[] public benefits;

    event BenefitLogged(string category, uint256 savings, string note, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logBenefit(string calldata category, uint256 savings, string calldata note) external onlyAdmin {
        benefits.push(Benefit(category, savings, note, block.timestamp));
        emit BenefitLogged(category, savings, note, block.timestamp);
    }

    function totalBenefits() external view returns (uint256) { return benefits.length; }

    function getBenefit(uint256 id) external view returns (Benefit memory) {
        require(id < benefits.length, "Invalid id");
        return benefits[id];
    }
}
