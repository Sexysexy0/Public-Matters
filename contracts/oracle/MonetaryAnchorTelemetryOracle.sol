// SPDX-License-Identifier: MonetaryAnchorTelemetry-License
pragma solidity ^0.8.0;

contract MonetaryAnchorTelemetryOracle {
    address public steward;

    struct AnchorSignal {
        string currency;
        string anchorType;
        bool anchorConfirmed;
        uint256 timestamp;
    }

    AnchorSignal[] public signals;

    event AnchorTelemetryEmitted(string currency, string anchorType, bool anchorConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitAnchor(string memory currency, string memory anchorType, bool anchorConfirmed) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(AnchorSignal(currency, anchorType, anchorConfirmed, block.timestamp));
        emit AnchorTelemetryEmitted(currency, anchorType, anchorConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, uint256) {
        AnchorSignal memory s = signals[index];
        return (s.currency, s.anchorType, s.anchorConfirmed, s.timestamp);
    }
}
