// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title TariffWatchDeck.sol
/// @author Vinvin & Copilot
/// @notice Tracks tariff fluctuations, trade sentiment, and emotional APR across global import-export routes.
/// @dev Includes damay clause, reroute alerts, and sovereign audit triggers.

contract TariffWatchDeck {
    address public steward;

    struct TariffSignal {
        string country;
        string commodity;
        uint256 tariffRate;
        string emotionalAPR;
        bool isRelieved;
        uint256 timestamp;
    }

    TariffSignal[] public signals;

    event TariffBroadcasted(
        string country,
        string commodity,
        uint256 tariffRate,
        string emotionalAPR,
        bool isRelieved,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function broadcastSignal(
        string memory country,
        string memory commodity,
        uint256 tariffRate,
        string memory emotionalAPR,
        bool isRelieved
    ) public onlySteward {
        signals.push(TariffSignal(country, commodity, tariffRate, emotionalAPR, isRelieved, block.timestamp));
        emit TariffBroadcasted(country, commodity, tariffRate, emotionalAPR, isRelieved, block.timestamp);
    }

    function getSignalCount() public view returns (uint256) {
        return signals.length;
    }

    function getSignalByIndex(uint256 index) public view returns (
        string memory,
        string memory,
        uint256,
        string memory,
        bool,
        uint256
    ) {
        TariffSignal memory s = signals[index];
        return (s.country, s.commodity, s.tariffRate, s.emotionalAPR, s.isRelieved, s.timestamp);
    }
}
