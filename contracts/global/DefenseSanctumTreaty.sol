// SPDX-License-Identifier: ArabNATOProtocol
pragma solidity ^0.8.19;

contract DefenseSanctumTreaty {
    address public steward;
    string public allianceName = "Arab-Islamic NATO";
    uint256 public ratifiedAt;

    struct MemberState {
        string name;
        bool ratified;
        uint256 timestamp;
    }

    MemberState[] public members;

    event TreatyRatified(string name, uint256 timestamp);
    event CeasefireBlessed(string region, string blessing, uint256 timestamp);
    event USBackedSignal(string message, uint256 timestamp);

    constructor() {
        steward = msg.sender;
        ratifiedAt = block.timestamp;
    }

    function ratifyMember(string memory name) public {
        require(msg.sender == steward, "Only steward may ratify");
        members.push(MemberState(name, true, block.timestamp));
        emit TreatyRatified(name, block.timestamp);
    }

    function blessCeasefire(string memory region, string memory blessing) public {
        require(msg.sender == steward, "Only steward may bless ceasefire");
        emit CeasefireBlessed(region, blessing, block.timestamp);
    }

    function signalUSBacked(string memory message) public {
        require(msg.sender == steward, "Only steward may signal");
        emit USBackedSignal(message, block.timestamp);
    }

    function getMember(uint256 index) public view returns (string memory, bool, uint256) {
        MemberState memory m = members[index];
        return (m.name, m.ratified, m.timestamp);
    }

    function totalMembers() public view returns (uint256) {
        return members.length;
    }
}
