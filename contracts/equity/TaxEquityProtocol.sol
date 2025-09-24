// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title TaxEquityProtocol
/// @author Vinvin
/// @notice Tracks tax burdens, relief flows, and emotional APR across income tiers
/// @dev Includes damay clause, fallback logic, and equity audit triggers

contract TaxEquityProtocol {
    enum IncomeTier { Low, Middle, High }
    
    struct TaxRecord {
        IncomeTier tier;
        uint256 amountPaid;
        uint256 reliefReceived;
        string emotionalAPR; // e.g., "High Empathy, Low Trust, Moderate Resonance"
        bool damayActivated;
    }

    mapping(address => TaxRecord) public taxRecords;
    address public treasury;
    event TaxLogged(address indexed taxpayer, IncomeTier tier, uint256 amountPaid);
    event ReliefDisbursed(address indexed taxpayer, uint256 amount, string reason);
    event DamayClauseTriggered(address indexed taxpayer, string emotionalAPR);

    modifier onlyTreasury() {
        require(msg.sender == treasury, "Not authorized");
        _;
    }

    constructor() {
        treasury = msg.sender;
    }

    function logTax(address taxpayer, IncomeTier tier, uint256 amountPaid, string memory emotionalAPR) public onlyTreasury {
        taxRecords[taxpayer] = TaxRecord(tier, amountPaid, 0, emotionalAPR, false);
        emit TaxLogged(taxpayer, tier, amountPaid);
    }

    function disburseRelief(address taxpayer, uint256 amount, string memory reason) public onlyTreasury {
        require(taxRecords[taxpayer].amountPaid > 0, "No tax record found");
        taxRecords[taxpayer].reliefReceived += amount;
        emit ReliefDisbursed(taxpayer, amount, reason);
    }

    function activateDamay(address taxpayer) public onlyTreasury {
        require(!taxRecords[taxpayer].damayActivated, "Already activated");
        taxRecords[taxpayer].damayActivated = true;
        emit DamayClauseTriggered(taxpayer, taxRecords[taxpayer].emotionalAPR);
    }

    function getTaxRecord(address taxpayer) public view returns (TaxRecord memory) {
        return taxRecords[taxpayer];
    }
}
