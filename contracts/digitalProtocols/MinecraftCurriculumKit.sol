// SPDX-License-Identifier: Mythic-MinecraftCurriculum
pragma solidity ^0.8.19;

contract MinecraftCurriculumKit {
    address public steward;

    struct GameplayAction {
        string player;
        string action;
        string civicMeaning;
        uint256 emotionalAPR;
        string tag;
        uint256 timestamp;
    }

    GameplayAction[] public ritualLog;

    event RitualLogged(
        string player,
        string action,
        string civicMeaning,
        uint256 emotionalAPR,
        string tag,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function logRitual(
        string memory player,
        string memory action,
        string memory civicMeaning,
        uint256 emotionalAPR,
        string memory tag
    ) public {
        require(msg.sender == steward, "Only steward may log.");

        GameplayAction memory ritual = GameplayAction({
            player: player,
            action: action,
            civicMeaning: civicMeaning,
            emotionalAPR: emotionalAPR,
            tag: tag,
            timestamp: block.timestamp
        });

        ritualLog.push(ritual);
        emit RitualLogged(player, action, civicMeaning, emotionalAPR, tag, block.timestamp);
    }

    function getRitual(uint index) public view returns (GameplayAction memory) {
        return ritualLog[index];
    }

    function totalRituals() public view returns (uint) {
        return ritualLog.length;
    }
}
