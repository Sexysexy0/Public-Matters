// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract AllianceLedger {
    struct Alliance {
        string actorA;
        string actorB;
        string terms;
        uint256 timestamp;
        bool active;
    }

    Alliance[] public alliances;

    event AllianceForged(string actorA, string actorB, string terms);

    function forgeAlliance(string memory actorA, string memory actorB, string memory terms) public {
        alliances.push(Alliance(actorA, actorB, terms, block.timestamp, true));
        emit AllianceForged(actorA, actorB, terms);
    }

    function getActiveAlliances() public view returns (Alliance[] memory) {
        return alliances;
    }
}
