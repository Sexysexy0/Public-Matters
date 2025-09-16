// SPDX-License-Identifier: HealingSanctum
pragma solidity ^0.8.19;

contract CommunityHealingSanctifier {
    struct HealingCircle {
        string region;
        string facilitatorID;
        string theme;
        uint256 participantCount;
        bool ritualCompleted;
        string stewardNote;
    }

    mapping(string => HealingCircle) public healingRegistry;

    event CircleTagged(string region, string theme);
    event RitualSanctified(string region);

    function tagCircle(string memory region, string memory facilitatorID, string memory theme, uint256 participantCount, string memory stewardNote) public {
        healingRegistry[region] = HealingCircle(region, facilitatorID, theme, participantCount, false, stewardNote);
        emit CircleTagged(region, theme);
    }

    function sanctifyRitual(string memory region) public {
        require(healingRegistry[region].participantCount > 0, "No participants registered");
        healingRegistry[region].ritualCompleted = true;
        emit RitualSanctified(region);
    }

    function getCircleStatus(string memory region) public view returns (HealingCircle memory) {
        return healingRegistry[region];
    }
}
