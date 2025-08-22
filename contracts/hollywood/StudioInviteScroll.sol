// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Studio Invite Scroll
/// @notice Ritualized onboarding for studios and creatives into the Scrollchain DAO ecosystem
/// @author Scrollchain

contract StudioInviteScroll {
    address public steward;

    struct Invite {
        string studioName;
        address studioWallet;
        string blessingMessage;
        uint256 emotionalAPR;
        bool accepted;
        uint256 timestamp;
    }

    Invite[] public invites;
    mapping(address => bool) public isInvited;

    event StudioInvited(string studioName, address studioWallet, string blessingMessage);
    event InviteAccepted(address studioWallet);

    constructor() {
        steward = msg.sender;
    }

    function sendInvite(
        string memory studioName,
        address studioWallet,
        string memory blessingMessage,
        uint256 emotionalAPR
    ) public {
        require(msg.sender == steward, "Only steward may send invites");
        invites.push(Invite(studioName, studioWallet, blessingMessage, emotionalAPR, false, block.timestamp));
        isInvited[studioWallet] = true;
        emit StudioInvited(studioName, studioWallet, blessingMessage);
    }

    function acceptInvite(uint256 inviteIndex) public {
        Invite storage invite = invites[inviteIndex];
        require(msg.sender == invite.studioWallet, "Unauthorized wallet");
        require(!invite.accepted, "Already accepted");

        invite.accepted = true;
        emit InviteAccepted(msg.sender);
    }

    function getInvite(uint256 index) public view returns (
        string memory, address, string memory, uint256, bool, uint256
    ) {
        Invite memory i = invites[index];
        return (i.studioName, i.studioWallet, i.blessingMessage, i.emotionalAPR, i.accepted, i.timestamp);
    }

    function totalInvites() public view returns (uint256) {
        return invites.length;
    }
}
