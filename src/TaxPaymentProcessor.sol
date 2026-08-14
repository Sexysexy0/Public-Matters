// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract TaxPaymentProcessor {
    address public immutable steward;
    ITrustIntegrator public trustIntegrator;
    uint256 public vatRate; // basis points, e.g., 1200 = 12%

    event TaxPaid(
        address indexed payer,
        uint256 amount,
        uint256 vatAmount,
        uint256 trustWeight,
        string category
    );
    event VatRateUpdated(uint256 newRate);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _trustIntegrator, uint256 _vatRate) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
        vatRate = _vatRate;
    }

    function setVatRate(uint256 _newRate) external onlySteward {
        vatRate = _newRate;
        emit VatRateUpdated(_newRate);
    }

    function setTrustIntegrator(address _newIntegrator) external onlySteward {
        trustIntegrator = ITrustIntegrator(_newIntegrator);
    }

    /**
     * @dev Pay tax – amount is the pre‑VAT base, category describes the tax type.
     * @param amount The base amount (without VAT)
     * @param category A short string, e.g., "income", "property", "sales"
     */
    function payTax(uint256 amount, string calldata category) external payable {
        require(amount > 0, "Amount must be > 0");

        uint256 vatAmount = (amount * vatRate) / 10000;
        uint256 total = amount + vatAmount;
        require(msg.value >= total, "Insufficient payment");

        // Trust weight: 1 point per 0.01 ETH paid (base amount)
        uint256 trustWeight = amount / 1e16;
        if (trustWeight == 0) trustWeight = 1;

        // Log positive action on TrustIntegratorV2
        trustIntegrator.logPositiveAction(
            string(abi.encodePacked("Tax: ", category)),
            trustWeight
        );

        emit TaxPaid(msg.sender, amount, vatAmount, trustWeight, category);

        // Refund excess
        if (msg.value > total) {
            payable(msg.sender).transfer(msg.value - total);
        }
    }

    receive() external payable {}
}
