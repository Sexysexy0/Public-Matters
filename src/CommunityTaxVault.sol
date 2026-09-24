// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract CommunityTaxVault {
    address public admin;
    mapping(address => uint256) public taxPaid;

    event TaxDeposited(address indexed taxpayer, uint256 amount, uint256 weight);

    constructor() {
        admin = msg.sender;
    }

    function depositTax(uint256 trustWeight) external payable {
        require(msg.value > 0, "Must send tax value");
        taxPaid[msg.sender] += msg.value;
        
        // Fixed: Emit the event BEFORE any external states or structural interaction
        emit TaxDeposited(msg.sender, msg.value, trustWeight);
    }
}
