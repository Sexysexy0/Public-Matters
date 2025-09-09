// SPDX-License-Identifier: DedollarizationSignal-License
pragma solidity ^0.8.0;

contract DedollarizationSignalRouter {
    address public steward;

    struct Signal {
        string country;
        string newCurrency;
        bool dedollarizationConfirmed;
        string sector;
        uint256 timestamp;
    }

    Signal[] public signals;

    event DedollarizationRouted(string country, string newCurrency, bool dedollarizationConfirmed, string sector, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory country, string memory newCurrency, bool dedollarizationConfirmed, string memory sector) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(Signal(country, newCurrency, dedollarizationConfirmed, sector, block.timestamp));
        emit DedollarizationRouted(country, newCurrency, dedollarizationConfirmed, sector, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        Signal memory s = signals[index];
        return (s.country, s.newCurrency, s.dedollarizationConfirmed, s.sector, s.timestamp);
    }
}
