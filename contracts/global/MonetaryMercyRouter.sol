// SPDX-License-Identifier: MonetarySanctum
pragma solidity ^0.8.19;

contract MonetaryMercyRouter {
    address public steward;

    struct MercySignal {
        string sector; // e.g. "Manufacturing", "Retail", "Logistics"
        string mercyType; // e.g. "Wage Support", "Loan Relief", "Emergency Stimulus"
        string trigger; // e.g. "Rate Cut", "Job Loss Spike", "Inflation Drag"
        bool verified;
        uint256 timestamp;
    }

    MercySignal[] public signals;

    event MercyLogged(string sector, string mercyType, string trigger, uint256 timestamp);
    event MercyVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logMercy(
        string memory sector,
        string memory mercyType,
        string memory trigger
    ) public {
        signals.push(MercySignal(sector, mercyType, trigger, false, block.timestamp));
        emit MercyLogged(sector, mercyType, trigger, block.timestamp);
    }

    function verifyMercy(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit MercyVerified(index, msg.sender);
    }

    function getMercy(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        MercySignal memory m = signals[index];
        return (m.sector, m.mercyType, m.trigger, m.verified, m.timestamp);
    }

    function totalMercySignals() public view returns (uint256) {
        return signals.length;
    }
}
