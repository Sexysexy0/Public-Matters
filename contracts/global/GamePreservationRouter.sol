// SPDX-License-Identifier: LegacySanctum
pragma solidity ^0.8.19;

contract GamePreservationRouter {
    struct PreservationSignal {
        address gameID;
        string gameName;
        string preservationType; // e.g., "Open-Source Fork", "NFT Migration", "DAO Continuation"
        bool archived;
        bool verified;
        string stewardNote;
    }

    mapping(address => PreservationSignal) public preservationRegistry;

    event GameTagged(address gameID, string preservationType);
    event GameVerified(address gameID);

    function tagGame(address gameID, string memory gameName, string memory preservationType, string memory stewardNote) public {
        preservationRegistry[gameID] = PreservationSignal(gameID, gameName, preservationType, false, false, stewardNote);
        emit GameTagged(gameID, preservationType);
    }

    function verifyGame(address gameID) public {
        require(bytes(preservationRegistry[gameID].gameName).length > 0, "Game not tagged");
        preservationRegistry[gameID].verified = true;
        emit GameVerified(gameID);
    }

    function archiveGame(address gameID) public {
        preservationRegistry[gameID].archived = true;
    }

    function getGameStatus(address gameID) public view returns (PreservationSignal memory) {
        return preservationRegistry[gameID];
    }
}
