// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToPricingSystemsAuditLedger {
    string public batchID = "1321.9.248";
    string public steward = "Vinvin";

    address public admin;

    struct Pricing {
        string product;     // rice, fuel, medicine
        string status;      // audited, pending, ghost
        uint256 timestamp;
    }

    Pricing[] public pricings;

    event PricingLogged(string product, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logPricing(string memory product, string memory status) public onlyAdmin {
        pricings.push(Pricing(product, status, block.timestamp));
        emit PricingLogged(product, status);
    }

    function getPricing(uint256 index) public view returns (string memory product, string memory status, uint256 timestamp) {
        Pricing memory p = pricings[index];
        return (p.product, p.status, p.timestamp);
    }
}
