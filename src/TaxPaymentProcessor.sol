// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract TaxPaymentProcessor {
    address public immutable steward;
    ITrustIntegrator public trustIntegrator;
    address public taxVault; // CommunityTaxVault address
    uint256 public vatRate; // basis points, e.g., 1200 = 12%

    event TaxPaid(
        address indexed payer,
        uint256 amount,
        uint256 vatAmount,
        uint256 trustWeight,
        string category
    );
    event VatRateUpdated(uint256 newRate);
    event TaxVaultUpdated(address newVault);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _trustIntegrator, uint256 _vatRate, address _taxVault) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
        vatRate = _vatRate;
        taxVault = _taxVault;
    }

    function setVatRate(uint256 _newRate) external onlySteward {
        vatRate = _newRate;
        emit VatRateUpdated(_newRate);
    }

    function setTrustIntegrator(address _newIntegrator) external onlySteward {
        trustIntegrator = ITrustIntegrator(_newIntegrator);
    }

    function setTaxVault(address _newVault) external onlySteward {
        taxVault = _newVault;
        emit TaxVaultUpdated(_newVault);
    }

    function payTax(uint256 amount, string calldata category) external payable {
        require(amount > 0, "Amount must be > 0");
        require(taxVault != address(0), "Tax vault not set");

        uint256 vatAmount = (amount * vatRate) / 10000;
        uint256 total = amount + vatAmount;
        require(msg.value >= total, "Insufficient payment");

        uint256 trustWeight = amount / 1e16;
        if (trustWeight == 0) trustWeight = 1;

        trustIntegrator.logPositiveAction(
            string(abi.encodePacked("Tax: ", category)),
            trustWeight
        );

        emit TaxPaid(msg.sender, amount, vatAmount, trustWeight, category);

        // Forward the payment to the tax vault
        (bool success, ) = taxVault.call{value: total}("");
        require(success, "Vault transfer failed");

        // Refund excess if any
        if (msg.value > total) {
            payable(msg.sender).transfer(msg.value - total);
        }
    }

    receive() external payable {}
}
