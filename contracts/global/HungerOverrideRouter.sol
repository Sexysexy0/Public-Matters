// SPDX-License-Identifier: HungerSanctum
pragma solidity ^0.8.19;

contract HungerOverrideRouter {
    address public steward;

    struct HungerSignal {
        string region; // e.g. "Bangsamoro", "Horn of Africa", "Urban Slums"
        string overrideType; // "Emergency Feeding", "Food Equity Trigger", "Scrollchain Blessing"
        string stewardTag; // e.g. "Relief Steward #8", "Equity Auditor #3"
        bool verified;
        uint256 timestamp;
    }

    HungerSignal[] public signals;

    event HungerLogged(string region, string overrideType, string stewardTag, uint256 timestamp);
    event HungerVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logHunger(
        string memory region,
        string memory overrideType,
        string memory stewardTag
    ) public {
        signals.push(HungerSignal(region, overrideType, stewardTag, false, block.timestamp));
        emit HungerLogged(region, overrideType, stewardTag, block.timestamp);
    }

    function verifyHunger(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit HungerVerified(index, msg.sender);
    }

    function getHunger(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        HungerSignal memory h = signals[index];
        return (h.region, h.overrideType, h.stewardTag, h.verified, h.timestamp);
    }

    function totalHungerSignals() public view returns (uint256) {
        return signals.length;
    }
}
