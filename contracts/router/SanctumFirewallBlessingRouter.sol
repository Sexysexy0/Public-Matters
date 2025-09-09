// SPDX-License-Identifier: SanctumFirewallBlessing-License
pragma solidity ^0.8.0;

contract SanctumFirewallBlessingRouter {
    address public steward;

    struct FirewallBlessing {
        string stewardID;
        string role;
        bool blessingConfirmed;
        string threatType;
        uint256 timestamp;
    }

    FirewallBlessing[] public blessings;

    event FirewallBlessed(string stewardID, string role, bool blessingConfirmed, string threatType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blessFirewall(string memory stewardID, string memory role, bool blessingConfirmed, string memory threatType) public {
        require(msg.sender == steward, "Only steward can bless");
        blessings.push(FirewallBlessing(stewardID, role, blessingConfirmed, threatType, block.timestamp));
        emit FirewallBlessed(stewardID, role, blessingConfirmed, threatType, block.timestamp);
    }

    function getBlessing(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        FirewallBlessing memory b = blessings[index];
        return (b.stewardID, b.role, b.blessingConfirmed, b.threatType, b.timestamp);
    }
}
