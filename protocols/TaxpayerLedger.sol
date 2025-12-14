// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TaxpayerLedger: record mandatory tax payments
contract TaxpayerLedger {
    struct Payment {
        uint256 id;
        string taxpayer;
        uint256 amount;
        string type;        // "Income Tax", "VAT", "Excise"
        bool onTime;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Payment) public payments;
    mapping(address => bool) public stewards;

    event PaymentLogged(uint256 indexed id, string taxpayer, uint256 amount, string type, bool onTime);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logPayment(string calldata taxpayer, uint256 amount, string calldata type, bool onTime) external {
        require(stewards[msg.sender], "Only steward");
        payments[nextId] = Payment(nextId, taxpayer, amount, type, onTime, block.timestamp);
        emit PaymentLogged(nextId, taxpayer, amount, type, onTime);
        nextId++;
    }
}
