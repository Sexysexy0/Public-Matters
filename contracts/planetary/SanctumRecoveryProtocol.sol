// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract SanctumRecoveryProtocol {
    struct RecoveryLog {
        string actor;
        uint empathyBoost;
        uint trustBoost;
        uint clarityBoost;
        bool confessionSubmitted;
        bool reformComplete;
    }

    mapping(string => RecoveryLog) public recoveryLogs;
    string[] public reformingActors;

    event ConfessionReceived(string actor);
    event ReformLogged(string actor);
    event ReentryApproved(string actor);

    function submitConfession(string memory _actor) public {
        recoveryLogs[_actor].confessionSubmitted = true;
        emit ConfessionReceived(_actor);
    }

    function logReform(
        string memory _actor,
        uint _empathyBoost,
        uint _trustBoost,
        uint _clarityBoost
    ) public {
        require(recoveryLogs[_actor].confessionSubmitted, "Confession required");

        recoveryLogs[_actor] = RecoveryLog(
            _actor,
            _empathyBoost,
            _trustBoost,
            _clarityBoost,
            true,
            true
        );
        reformingActors.push(_actor);
        emit ReformLogged(_actor);
        emit ReentryApproved(_actor);
    }

    function getReformingActors() public view returns (string[] memory) {
        return reformingActors;
    }

    function isReformComplete(string memory _actor) public view returns (bool) {
        return recoveryLogs[_actor].reformComplete;
    }
}
