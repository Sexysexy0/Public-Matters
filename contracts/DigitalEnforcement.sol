// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DigitalEnforcement
/// @notice Covenant contract to automate tax compliance and reduce corruption
contract DigitalEnforcement {
    address public owner;

    struct Taxpayer {
        string name;
        uint256 declaredIncome;
        uint256 taxPaid;
        bool compliant;
    }

    mapping(address => Taxpayer) public taxpayers;

    event TaxpayerRegistered(address taxpayer, string name);
    event ComplianceChecked(address taxpayer, bool compliant);
    event IncomeDeclared(address taxpayer, uint256 amount, uint256 taxPaid);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerTaxpayer(address taxpayerAddr, string memory name) public onlyOwner {
        taxpayers[taxpayerAddr] = Taxpayer(name, 0, 0, false);
        emit TaxpayerRegistered(taxpayerAddr, name);
    }

    function declareIncome(address taxpayerAddr, uint256 income, uint256 taxPaid) public onlyOwner {
        Taxpayer storage tp = taxpayers[taxpayerAddr];
        tp.declaredIncome = income;
        tp.taxPaid = taxPaid;
        emit IncomeDeclared(taxpayerAddr, income, taxPaid);
    }

    function checkCompliance(address taxpayerAddr, uint256 requiredRate) public onlyOwner {
        Taxpayer storage tp = taxpayers[taxpayerAddr];
        require(bytes(tp.name).length > 0, "Taxpayer not registered");

        uint256 effectiveRate = (tp.taxPaid * 100) / tp.declaredIncome;
        tp.compliant = effectiveRate >= requiredRate;

        emit ComplianceChecked(taxpayerAddr, tp.compliant);
    }
}
