// SPDX-License-Identifier: MacroSignalSanctum
pragma solidity ^0.8.19;

contract MacroCatalystScanner {
    address public steward;

    struct CatalystEvent {
        string catalystTag; // e.g. "Fed Rate Cut", "Geopolitical Shock", "AI Regulation"
        string affectedAsset; // e.g. "QQQ", "NVDA", "MAGX"
        string impactSignal; // e.g. "Volatility Spike", "Earnings Revision", "Sector Rotation"
        bool verified;
        uint256 timestamp;
    }

    CatalystEvent[] public events;

    event CatalystLogged(string catalystTag, string affectedAsset, string impactSignal, uint256 timestamp);
    event CatalystVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logCatalyst(
        string memory catalystTag,
        string memory affectedAsset,
        string memory impactSignal
    ) public {
        events.push(CatalystEvent(catalystTag, affectedAsset, impactSignal, false, block.timestamp));
        emit CatalystLogged(catalystTag, affectedAsset, impactSignal, block.timestamp);
    }

    function verifyCatalyst(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].verified = true;
        emit CatalystVerified(index, msg.sender);
    }

    function getCatalyst(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        CatalystEvent memory c = events[index];
        return (c.catalystTag, c.affectedAsset, c.impactSignal, c.verified, c.timestamp);
    }

    function totalCatalysts() public view returns (uint256) {
        return events.length;
    }
}
