// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract TariffOverrideTreaty {
    address public steward;
    mapping(address => bool) public blessedPartners;
    mapping(address => bool) public rogueSanctums;

    event TreatyActivated(address indexed steward);
    event PartnerBlessed(address indexed partner);
    event TariffNullified(address indexed sender, uint256 timestamp);

    constructor() {
        steward = msg.sender;
        emit TreatyActivated(steward);
    }

    function blessPartner(address _partner) external {
        require(msg.sender == steward, "Only steward may bless");
        blessedPartners[_partner] = true;
        emit PartnerBlessed(_partner);
    }

    function nullifyTariff(address _sender) external {
        require(blessedPartners[_sender], "Sender not blessed");
        emit TariffNullified(_sender, block.timestamp);
    }

    function markRogue(address _sanctum) external {
        require(msg.sender == steward, "Only steward may mark rogue");
        rogueSanctums[_sanctum] = true;
    }
}
