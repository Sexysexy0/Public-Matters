// SPDX-License-Identifier: VolatilitySanctum
pragma solidity ^0.8.19;

contract PortfolioVolatilityScanner {
    address public steward;

    struct VolatilityEvent {
        string portfolioTag; // e.g. "Retail", "Institutional", "ETF"
        string triggerTag; // e.g. "AI Overexposure", "Rate Cut", "Earnings Miss"
        int256 volatilityScore; // e.g. -100 to +100
        string riskSignal; // e.g. "Overconcentrated", "Unhedged", "Momentum Fragility"
        bool verified;
        uint256 timestamp;
    }

    VolatilityEvent[] public events;

    event VolatilityLogged(string portfolioTag, string triggerTag, int256 volatilityScore, string riskSignal, uint256 timestamp);
    event VolatilityVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logVolatility(
        string memory portfolioTag,
        string memory triggerTag,
        int256 volatilityScore,
        string memory riskSignal
    ) public {
        events.push(VolatilityEvent(portfolioTag, triggerTag, volatilityScore, riskSignal, false, block.timestamp));
        emit VolatilityLogged(portfolioTag, triggerTag, volatilityScore, riskSignal, block.timestamp);
    }

    function verifyVolatility(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].verified = true;
        emit VolatilityVerified(index, msg.sender);
    }

    function getVolatility(uint256 index) public view returns (
        string memory, string memory, int256, string memory, bool, uint256
    ) {
        VolatilityEvent memory v = events[index];
        return (v.portfolioTag, v.triggerTag, v.volatilityScore, v.riskSignal, v.verified, v.timestamp);
    }

    function totalVolatilityEvents() public view returns (uint256) {
        return events.length;
    }
}
