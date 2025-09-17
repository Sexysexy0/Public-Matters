// SPDX-License-Identifier: PortfolioSanctum
pragma solidity ^0.8.19;

contract DiversificationBlessingRouter {
    address public steward;

    struct DiversificationEvent {
        string portfolioTag; // e.g. "Retail", "Institutional", "ETF"
        string assetClass; // e.g. "Equity", "Fixed Income", "Commodities"
        string sectorSpread; // e.g. "Tech-Heavy", "Balanced", "Underweight AI"
        bool blessed;
        uint256 timestamp;
    }

    DiversificationEvent[] public events;

    event DiversificationLogged(string portfolioTag, string assetClass, string sectorSpread, uint256 timestamp);
    event DiversificationBlessed(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logDiversification(
        string memory portfolioTag,
        string memory assetClass,
        string memory sectorSpread
    ) public {
        events.push(DiversificationEvent(portfolioTag, assetClass, sectorSpread, false, block.timestamp));
        emit DiversificationLogged(portfolioTag, assetClass, sectorSpread, block.timestamp);
    }

    function blessDiversification(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].blessed = true;
        emit DiversificationBlessed(index, msg.sender);
    }

    function getDiversification(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        DiversificationEvent memory d = events[index];
        return (d.portfolioTag, d.assetClass, d.sectorSpread, d.blessed, d.timestamp);
    }

    function totalDiversifications() public view returns (uint256) {
        return events.length;
    }
}
