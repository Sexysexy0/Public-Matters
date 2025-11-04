// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserSovereigntyCodex {
    address public steward;

    struct SovereigntyEntry {
        string userRight;
        string platformThreat;
        string defenseProtocol;
        string emotionalTag;
    }

    SovereigntyEntry[] public codex;

    event UserSovereigntyLogged(string userRight, string platformThreat, string defenseProtocol, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function logSovereignty(
        string memory userRight,
        string memory platformThreat,
        string memory defenseProtocol,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(SovereigntyEntry(userRight, platformThreat, defenseProtocol, emotionalTag));
        emit UserSovereigntyLogged(userRight, platformThreat, defenseProtocol, emotionalTag);
    }
}
