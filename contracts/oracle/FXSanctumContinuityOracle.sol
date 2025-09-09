// SPDX-License-Identifier: FXSanctumContinuity-License
pragma solidity ^0.8.0;

contract FXSanctumContinuityOracle {
    address public steward;

    struct FXSignal {
        string currency;
        string region;
        bool continuityConfirmed;
        string clauseType;
        uint256 timestamp;
    }

    FXSignal[] public signals;

    event FXContinuityEmitted(string currency, string region, bool continuityConfirmed, string clauseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitContinuity(string memory currency, string memory region, bool continuityConfirmed, string memory clauseType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(FXSignal(currency, region, continuityConfirmed, clauseType, block.timestamp));
        emit FXContinuityEmitted(currency, region, continuityConfirmed, clauseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        FXSignal memory s = signals[index];
        return (s.currency, s.region, s.continuityConfirmed, s.clauseType, s.timestamp);
    }
}
