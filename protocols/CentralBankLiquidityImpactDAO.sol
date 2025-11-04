// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CentralBankLiquidityImpactDAO {
    address public steward;

    struct LiquidityImpact {
        string centralBank;
        string policyAction;
        string cryptoResponse;
        string emotionalTag;
    }

    LiquidityImpact[] public registry;

    event LiquidityImpactTagged(string centralBank, string policyAction, string cryptoResponse, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImpact(
        string memory centralBank,
        string memory policyAction,
        string memory cryptoResponse,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(LiquidityImpact(centralBank, policyAction, cryptoResponse, emotionalTag));
        emit LiquidityImpactTagged(centralBank, policyAction, cryptoResponse, emotionalTag);
    }
}
