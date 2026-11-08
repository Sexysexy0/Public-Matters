// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title MarriageRegistry
 * @notice On-chain marriage contract for game characters.
 *         Allows proposing, accepting, and crowning a Queen.
 */
contract MarriageRegistry {
    OperatorPrivileges public immutable privileges;

    enum MarriageStatus { NONE, PROPOSED, MARRIED, DIVORCED }

    struct Marriage {
        bytes32 id;
        bytes32 proposerHash; // Kliff
        bytes32 partnerHash;  // Damiane
        bytes32 dowryHash;    // Assets transferred
        bool isQueen;
        MarriageStatus status;
        uint256 marriedAt;
    }

    mapping(bytes32 => Marriage) public marriages;

    event MarriageProposed(bytes32 indexed id, bytes32 indexed proposer, bytes32 indexed partner);
    event MarriageAccepted(bytes32 indexed id);
    event CrownedQueen(bytes32 indexed id, bytes32 indexed queen);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function proposeMarriage(bytes32 proposerHash, bytes32 partnerHash, bytes32 dowryHash) external returns (bytes32) {
        bytes32 id = keccak256(abi.encode(proposerHash, partnerHash, block.timestamp));
        require(marriages[id].marriedAt == 0, "Proposal exists");

        marriages[id] = Marriage({
            id: id,
            proposerHash: proposerHash,
            partnerHash: partnerHash,
            dowryHash: dowryHash,
            isQueen: false,
            status: MarriageStatus.PROPOSED,
            marriedAt: 0
        });

        emit MarriageProposed(id, proposerHash, partnerHash);
        return id;
    }

    function getMarriage(bytes32 id) external view returns (Marriage memory) {
        return marriages[id];
    }

    function acceptMarriage(bytes32 marriageId) external onlyOperator {
        Marriage storage m = marriages[marriageId];
        require(m.status == MarriageStatus.PROPOSED, "Not proposed");
        m.status = MarriageStatus.MARRIED;
        m.marriedAt = block.timestamp;
        emit MarriageAccepted(marriageId);
    }

    function crownAsQueen(bytes32 marriageId) external onlyOperator {
        Marriage storage m = marriages[marriageId];
        require(m.status == MarriageStatus.MARRIED, "Not married");
        m.isQueen = true;
        emit CrownedQueen(marriageId, m.partnerHash);
    }
}
