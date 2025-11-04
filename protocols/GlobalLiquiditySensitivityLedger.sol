// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalLiquiditySensitivityLedger {
    address public steward;

    struct SensitivityEntry {
        string assetName;
        string centralBankPolicy;
        string liquidityResponse;
        string emotionalTag;
    }

    SensitivityEntry[] public ledger;

    event LiquiditySensitivityTagged(string assetName, string centralBankPolicy, string liquidityResponse, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagSensitivity(
        string memory assetName,
        string memory centralBankPolicy,
        string memory liquidityResponse,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(SensitivityEntry(assetName, centralBankPolicy, liquidityResponse, emotionalTag));
        emit LiquiditySensitivityTagged(assetName, centralBankPolicy, liquidityResponse, emotionalTag);
    }
}
