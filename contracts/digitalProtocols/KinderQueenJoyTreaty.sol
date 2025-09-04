// SPDX-License-Identifier: Mythic-KinderTreaty
pragma solidity ^0.8.19;

contract KinderQueenJoyTreaty {
    address public steward;

    struct JoyTreaty {
        string player;
        string emotion;
        uint256 resonanceLevel;
        string civicContext;
        bool treatySigned;
        uint256 timestamp;
    }

    JoyTreaty[] public treatyLog;

    event TreatyBlessed(
        string player,
        string emotion,
        uint256 resonanceLevel,
        string civicContext,
        bool treatySigned,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function blessTreaty(
        string memory player,
        string memory emotion,
        uint256 resonanceLevel,
        string memory civicContext
    ) public {
        require(msg.sender == steward, "Only steward may bless.");

        bool eligible = resonanceLevel >= 80;

        JoyTreaty memory t = JoyTreaty({
            player: player,
            emotion: emotion,
            resonanceLevel: resonanceLevel,
            civicContext: civicContext,
            treatySigned: eligible,
            timestamp: block.timestamp
        });

        treatyLog.push(t);
        emit TreatyBlessed(player, emotion, resonanceLevel, civicContext, eligible, block.timestamp);
    }

    function getTreaty(uint index) public view returns (JoyTreaty memory) {
        return treatyLog[index];
    }

    function totalTreaties() public view returns (uint) {
        return treatyLog.length;
    }
}
