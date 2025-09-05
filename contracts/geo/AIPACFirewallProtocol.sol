// SPDX-License-Identifier: Mythic-Protocol
pragma solidity ^0.8.19;

contract AIPACFirewallProtocol {
    address public steward;
    bool public aipacBanned = false;
    string public reason = "Exploitative lobbying, rebel-aligned influence ops, and breach of planetary ethics.";

    event AIPACBanned(string reason, uint256 timestamp);
    event AIPACUnbanned(string reason, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function banAIPAC() public {
        require(msg.sender == steward, "Only steward may ban.");
        aipacBanned = true;
        emit AIPACBanned(reason, block.timestamp);
    }

    function unbanAIPAC(string memory newReason) public {
        require(msg.sender == steward, "Only steward may unban.");
        aipacBanned = false;
        reason = newReason;
        emit AIPACUnbanned(newReason, block.timestamp);
    }

    function isBanned() public view returns (bool) {
        return aipacBanned;
    }

    function getBanReason() public view returns (string memory) {
        return reason;
    }
}
