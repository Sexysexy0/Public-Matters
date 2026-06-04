// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TaxReformReset
/// @notice Covenant contract to safeguard middle class and reset enforcement
contract TaxReformReset {
    address public owner;
    uint256 public taxFreeThreshold = 1_000_000 ether; // ₱1M exemption

    mapping(address => uint256) public declaredIncome;
    mapping(address => bool) public auditedOfficials;
    bool public birAbolished = false;

    event ThresholdUpdated(uint256 newThreshold);
    event IncomeDeclared(address taxpayer, uint256 amount);
    event AuditTriggered(address official);
    event BIRAbolished(bool status);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function updateThreshold(uint256 newThreshold) public onlyOwner {
        taxFreeThreshold = newThreshold;
        emit ThresholdUpdated(newThreshold);
    }

    function declareIncome(uint256 amount) public {
        declaredIncome[msg.sender] = amount;
        emit IncomeDeclared(msg.sender, amount);
    }

    function triggerAudit(address official) public onlyOwner {
        auditedOfficials[official] = true;
        emit AuditTriggered(official);
    }

    function abolishBIR() public onlyOwner {
        birAbolished = true;
        emit BIRAbolished(true);
    }

    function isTaxExempt(address taxpayer) public view returns (bool) {
        return declaredIncome[taxpayer] <= taxFreeThreshold;
    }
}
