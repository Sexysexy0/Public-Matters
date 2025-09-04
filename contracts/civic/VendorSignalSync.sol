// SPDX-License-Identifier: Mythic-VendorSync
pragma solidity ^0.8.19;

interface ICivicPulse {
    function broadcastPulse(address bidder) external;
}

contract VendorSignalSync {
    address public steward;
    ICivicPulse public pulseFeed;

    mapping(address => bool) public onboardedVendors;
    mapping(address => uint256) public lastPulseTimestamp;

    event VendorOnboarded(address indexed vendor, uint256 timestamp);
    event PulseSynced(address indexed vendor, uint256 timestamp);

    constructor(address _pulseFeed) {
        steward = msg.sender;
        pulseFeed = ICivicPulse(_pulseFeed);
    }

    function syncVendor(address vendor) public {
        require(msg.sender == steward, "Only steward may sync.");
        pulseFeed.broadcastPulse(vendor);
        lastPulseTimestamp[vendor] = block.timestamp;
        onboardedVendors[vendor] = true;
        emit PulseSynced(vendor, block.timestamp);
        emit VendorOnboarded(vendor, block.timestamp);
    }

    function isOnboarded(address vendor) public view returns (bool) {
        return onboardedVendors[vendor];
    }
}
