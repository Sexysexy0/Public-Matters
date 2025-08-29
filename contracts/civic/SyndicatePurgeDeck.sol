// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract SyndicatePurgeDeck {
    address public steward;

    struct RogueActor {
        string name;
        address wallet;
        string violation;
        bool frozen;
        bool referredToJustice;
    }

    RogueActor[] public purged;

    event ActorPurged(string name, string violation);
    event AssetsFrozen(address wallet);
    event JusticeReferral(address wallet);

    constructor() {
        steward = msg.sender;
    }

    function purgeActor(string memory name, address wallet, string memory violation) public {
        purged.push(RogueActor(name, wallet, violation, true, true));
        emit ActorPurged(name, violation);
        emit AssetsFrozen(wallet);
        emit JusticeReferral(wallet);
    }

    function getPurged(uint256 index) public view returns (RogueActor memory) {
        return purged[index];
    }

    function totalPurged() public view returns (uint256) {
        return purged.length;
    }
}
