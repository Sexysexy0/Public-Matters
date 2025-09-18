// SPDX-License-Identifier: SurvivalSanctum
pragma solidity ^0.8.19;

contract PriceSanctifier {
    address public steward;

    struct PriceSignal {
        string item; // e.g. "Rice", "Electricity", "Medicine"
        uint256 price; // in PHP or USD
        string breachType; // e.g. "Inflation Spike", "Supply Shock", "Speculative Surge"
        string mercyOverride; // e.g. "Price Cap", "Subsidy", "Emergency Relief"
        bool verified;
        uint256 timestamp;
    }

    PriceSignal[] public signals;

    event PriceLogged(string item, uint256 price, string breachType, string mercyOverride, uint256 timestamp);
    event PriceVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logPrice(
        string memory item,
        uint256 price,
        string memory breachType,
        string memory mercyOverride
    ) public {
        signals.push(PriceSignal(item, price, breachType, mercyOverride, false, block.timestamp));
        emit PriceLogged(item, price, breachType, mercyOverride, block.timestamp);
    }

    function verifyPrice(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit PriceVerified(index, msg.sender);
    }

    function getPrice(uint256 index) public view returns (
        string memory, uint256, string memory, string memory, bool, uint256
    ) {
        PriceSignal memory p = signals[index];
        return (p.item, p.price, p.breachType, p.mercyOverride, p.verified, p.timestamp);
    }

    function totalPriceSignals() public view returns (uint256) {
        return signals.length;
    }
}
