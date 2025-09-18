// SPDX-License-Identifier: InflationSanctum
pragma solidity ^0.8.19;

contract InflationSignalRouter {
    address public steward;

    struct InflationSignal {
        string category; // e.g. "Food", "Energy", "Housing"
        string type; // "One-Time Spike", "Systemic Pressure"
        string source; // e.g. "Tariff", "Supply Chain", "Wage Spiral"
        bool verified;
        uint256 timestamp;
    }

    InflationSignal[] public signals;

    event InflationLogged(string category, string type, string source, uint256 timestamp);
    event InflationVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logInflation(
        string memory category,
        string memory type,
        string memory source
    ) public {
        signals.push(InflationSignal(category, type, source, false, block.timestamp));
        emit InflationLogged(category, type, source, block.timestamp);
    }

    function verifyInflation(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit InflationVerified(index, msg.sender);
    }

    function getInflation(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        InflationSignal memory i = signals[index];
        return (i.category, i.type, i.source, i.verified, i.timestamp);
    }

    function totalInflationSignals() public view returns (uint256) {
        return signals.length;
    }
}
