// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title RoyalCourtRegistry
 * @notice On-chain record of petitions from nobles/peasants and 
 *         dispatch missions assigned from the Throne Room.
 */
contract RoyalCourtRegistry {
    OperatorPrivileges public immutable privileges;

    enum MissionStatus { PENDING, DISPATCHED, COMPLETED, FAILED }

    struct Petition {
        bytes32 id;
        bytes32 requesterHash; // Noble, vendor, or peasant
        bytes32 requestHash;   // The actual issue or mission details
        bytes32 assignedHero;  // e.g., Kliff or Damiane
        MissionStatus status;
        uint256 timestamp;
    }

    mapping(bytes32 => Petition) public petitions;
    uint256 public totalPetitions;

    event PetitionFiled(bytes32 indexed id, bytes32 indexed requesterHash, bytes32 requestHash);
    event MissionDispatched(bytes32 indexed id, bytes32 indexed assignedHero);
    event MissionCompleted(bytes32 indexed id, bool success);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function filePetition(bytes32 requesterHash, bytes32 requestHash) external returns (bytes32) {
        bytes32 id = keccak256(abi.encode(requesterHash, requestHash, block.timestamp, totalPetitions));
        require(petitions[id].timestamp == 0, "Petition exists");

        totalPetitions++;
        petitions[id] = Petition({
            id: id,
            requesterHash: requesterHash,
            requestHash: requestHash,
            assignedHero: bytes32(0),
            status: MissionStatus.PENDING,
            timestamp: block.timestamp
        });

        emit PetitionFiled(id, requesterHash, requestHash);
        return id;
    }

    function getPetition(bytes32 id) external view returns (Petition memory) {
        return petitions[id];
    }

    function dispatchMission(bytes32 petitionId, bytes32 heroHash) external onlyOperator {
        Petition storage p = petitions[petitionId];
        require(p.status == MissionStatus.PENDING, "Not pending");
        p.assignedHero = heroHash;
        p.status = MissionStatus.DISPATCHED;
        emit MissionDispatched(petitionId, heroHash);
    }

    function completeMission(bytes32 petitionId, bool success) external onlyOperator {
        Petition storage p = petitions[petitionId];
        require(p.status == MissionStatus.DISPATCHED, "Not dispatched");
        p.status = success ? MissionStatus.COMPLETED : MissionStatus.FAILED;
        emit MissionCompleted(petitionId, success);
    }
}
