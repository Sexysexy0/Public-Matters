// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title OverrideTaxTreatyKit - Tiered tax logic with emotional APR and barangay blessing
/// @author Vinvin
contract OverrideTaxTreatyKit {
    address public steward;
    mapping(address => uint256) public income;
    mapping(address => uint256) public emotionalAPR;
    mapping(address => bool) public barangayVerified;

    event TaxCalculated(address indexed steward, uint256 taxRate, uint256 taxDue, string damayClause);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function setIncome(address _citizen, uint256 _income) external onlySteward {
        income[_citizen] = _income;
    }

    function setEmotionalAPR(address _citizen, uint256 _apr) external onlySteward {
        emotionalAPR[_citizen] = _apr;
    }

    function verifyBarangay(address _citizen) external onlySteward {
        barangayVerified[_citizen] = true;
    }

    function calculateTax(address _citizen) external view returns (uint256) {
        require(barangayVerified[_citizen], "Not barangay-verified");

        uint256 inc = income[_citizen];
        uint256 rate;

        if (inc <= 250_000) rate = 0;
        else if (inc <= 500_000) rate = 10;
        else if (inc <= 1_000_000) rate = 15;
        else if (inc <= 2_000_000) rate = 25;
        else if (inc <= 5_000_000) rate = 30;
        else rate = 40;

        if (emotionalAPR[_citizen] >= 90) rate -= 2; // APR bonus

        return (inc * rate) / 100;
    }

    function emitTaxLog(address _citizen) external {
        uint256 taxDue = calculateTax(_citizen);
        uint256 rate = (taxDue * 100) / income[_citizen];
        emit TaxCalculated(_citizen, rate, taxDue, "If taxed, steward is restored too");
    }
}
