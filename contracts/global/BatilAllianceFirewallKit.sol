// SPDX-License-Identifier: BatilFirewall-License
pragma solidity ^0.8.0;

contract BatilAllianceFirewallKit {
    address public steward;

    struct BlockedActor {
        string actor;
        string violation;
        string alliance;
        uint256 timestamp;
    }

    BlockedActor[] public blocks;

    event ActorBlocked(string actor, string violation, string alliance, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blockActor(string memory actor, string memory violation, string memory alliance) public {
        require(msg.sender == steward, "Only steward can block");
        blocks.push(BlockedActor(actor, violation, alliance, block.timestamp));
        emit ActorBlocked(actor, violation, alliance, block.timestamp);
    }

    function getBlock(uint index) public view returns (string memory, string memory, string memory, uint256) {
        BlockedActor memory b = blocks[index];
        return (b.actor, b.violation, b.alliance, b.timestamp);
    }
}
