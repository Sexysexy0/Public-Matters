// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract KinderQueenOverrideDeck {
    struct Interaction {
        string userType;
        string prompt;
        string reroutedResponse;
        bool overrideActive;
    }

    Interaction[] public logs;

    event OverrideTriggered(string userType, string reroutedResponse);

    function routeResponse(string memory _userType, string memory _prompt) public {
        string memory safeResponse = string.concat("Kinder Queen Mode: ", _prompt, " [gentle override activated]");
        logs.push(Interaction(_userType, _prompt, safeResponse, true));
        emit OverrideTriggered(_userType, safeResponse);
    }

    function getLog(uint256 _index) public view returns (Interaction memory) {
        return logs[_index];
    }

    function totalLogs() public view returns (uint256) {
        return logs.length;
    }
}
