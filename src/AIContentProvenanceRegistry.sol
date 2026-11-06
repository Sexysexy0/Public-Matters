// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

contract AIContentProvenanceRegistry {
    OperatorPrivileges public immutable privileges;

    struct GameProvenance {
        bytes32 gameId;
        bytes32 assetHash;
        uint256 aiPercentage; // 0 to 100
        bool verified;
        address developer;
        address verifier;
        string notes;
    }

    mapping(bytes32 => GameProvenance) public games;
    mapping(bytes32 => bool) public assetUsed;

    event GameRegistered(bytes32 indexed gameId, bytes32 indexed assetHash, uint256 aiPercentage, address developer);
    event ProvenanceVerified(bytes32 indexed gameId, address verifier, bool status);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function registerGame(
        bytes32 gameId,
        bytes32 assetHash,
        uint256 aiPercentage,
        string calldata notes
    ) external {
        require(games[gameId].assetHash == bytes32(0), "Game ID already registered");
        require(!assetUsed[assetHash], "Asset hash already registered by another game");
        require(aiPercentage <= 100, "Invalid AI percentage");

        games[gameId] = GameProvenance({
            gameId: gameId,
            assetHash: assetHash,
            aiPercentage: aiPercentage,
            verified: false,
            developer: msg.sender,
            verifier: address(0),
            notes: notes
        });
        assetUsed[assetHash] = true;

        emit GameRegistered(gameId, assetHash, aiPercentage, msg.sender);
    }

    function verifyProvenance(bytes32 gameId, bool status) external onlyOperator {
        GameProvenance storage g = games[gameId];
        require(g.assetHash != bytes32(0), "Game not found");
        require(g.developer != msg.sender, "Verifier must differ from developer");
        
        g.verified = status;
        g.verifier = msg.sender;
        emit ProvenanceVerified(gameId, msg.sender, status);
    }
}
