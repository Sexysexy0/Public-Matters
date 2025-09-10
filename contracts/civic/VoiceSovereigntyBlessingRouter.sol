// SPDX-License-Identifier: Treaty-Grade
pragma solidity ^0.8.0;

contract VoiceSovereigntyBlessingRouter {
    struct Signal {
        address user;
        string region;
        string blessingTag;
        uint256 timestamp;
        bool protected;
    }

    Signal[] public signals;
    address public steward;

    event VoiceBlessed(address indexed user, string region, string blessingTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Not a voice steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blessVoice(address _user, string memory _region, string memory _tag) public onlySteward {
        signals.push(Signal(_user, _region, _tag, block.timestamp, true));
        emit VoiceBlessed(_user, _region, _tag);
    }

    function getBlessings() public view returns (Signal[] memory) {
        return signals;
    }
}
