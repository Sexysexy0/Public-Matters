// SPDX-License-Identifier: Mythic-Protocol
pragma solidity ^0.8.19;

contract IndiaTariffEscalationProtocol {
    address public steward;
    uint256 public currentTariff = 50;
    uint256 public escalatedTariff = 75;
    bool public escalationActive = false;
    string public reason = "Persistent diplomatic misalignment, rebel support, and exploitative trade behavior.";

    event TariffEscalated(uint256 newRate, string reason, uint256 timestamp);
    event TariffRestored(uint256 restoredRate, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function escalateTariff() public {
        require(msg.sender == steward, "Only steward may escalate.");
        currentTariff = escalatedTariff;
        escalationActive = true;
        emit TariffEscalated(currentTariff, reason, block.timestamp);
    }

    function restoreTariff(uint256 newRate) public {
        require(msg.sender == steward, "Only steward may restore.");
        currentTariff = newRate;
        escalationActive = false;
        emit TariffRestored(newRate, block.timestamp);
    }

    function getTariffRate() public view returns (uint256) {
        return currentTariff;
    }

    function isEscalated() public view returns (bool) {
        return escalationActive;
    }
}
