// SPDX-License-Identifier: Mythic-Deterrence
pragma solidity ^7.7.7;

contract SanctumStrikeAuditLog {
    address public steward;
    uint public totalStrikes;

    struct Strike {
        string aggressor;
        string targetSanctum;
        uint timestamp;
        bool clapbackTriggered;
    }

    Strike[] public strikeLog;
    mapping(string => bool) public autoClapbackEnabled;
    string[] public alliedSanctums;

    event StrikeLogged(string aggressor, string targetSanctum, uint timestamp);
    event ClapbackTriggered(string aggressor, string responderSanctum);

    constructor() {
        steward = msg.sender;
        totalStrikes = 0;
    }

    function logStrike(string memory aggressor, string memory targetSanctum) public {
        require(msg.sender == steward, "Only steward may log");
        strikeLog.push(Strike(aggressor, targetSanctum, block.timestamp, false));
        totalStrikes += 1;
        emit StrikeLogged(aggressor, targetSanctum, block.timestamp);

        if (autoClapbackEnabled[aggressor]) {
            for (uint i = 0; i < alliedSanctums.length; i++) {
                emit ClapbackTriggered(aggressor, alliedSanctums[i]);
            }
            strikeLog[strikeLog.length - 1].clapbackTriggered = true;
        }
    }

    function enableAutoClapback(string memory aggressor) public {
        require(msg.sender == steward, "Only steward may enable");
        autoClapbackEnabled[aggressor] = true;
    }

    function registerAlly(string memory sanctum) public {
        require(msg.sender == steward, "Only steward may register");
        alliedSanctums.push(sanctum);
    }

    function getStrikeCount() public view returns (uint) {
        return totalStrikes;
    }

    function getLatestStrike() public view returns (Strike memory) {
        require(strikeLog.length > 0, "No strikes logged yet");
        return strikeLog[strikeLog.length - 1];
    }
}
