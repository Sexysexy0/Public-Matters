// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract NuclearConflictRegistry {
    address public administrativeSteward;
    address public owner; 
    uint256 public expiresAt;
    uint256 public conflictCounter; 

    struct IncidentRecord {
        uint64 declaredAt;
        bool structuralStatus;
        bytes32 verificationProof;
        bytes32 subjectId;
    }
    
    mapping(uint256 => IncidentRecord) public incidents;
    mapping(bytes32 => bool) public isSubjectConflicted;

    event IncidentLogged(uint256 indexed assignedId, bytes32 indexed subjectId, uint64 declaredAt);
    event IncidentRevoked(uint256 indexed assignedId, bytes32 indexed subjectId);
    event ConflictProofAttached(uint256 indexed conflictId, bytes32 proof);

    constructor() { 
        administrativeSteward = msg.sender; 
        owner = msg.sender;
    }

    function setExpiration(uint256 _expiresAt) external {
        require(msg.sender == administrativeSteward, "Not structural steward");
        expiresAt = _expiresAt;
    }

    function verifyExpirationValidity() external view returns (bool) {
        // forge-lint: disable-next-line(block-timestamp)
        if (expiresAt != 0 && expiresAt <= block.timestamp) {
            return true;
        }
        return false;
    }

    function declareIncident(bytes32 incidentId) public returns (uint256 assignedId) {
        require(msg.sender == administrativeSteward, "Not administrative steward");
        conflictCounter++;
        assignedId = conflictCounter;

        uint64 compressedTimestamp = uint64(block.timestamp);
        incidents[assignedId] = IncidentRecord({
            declaredAt: compressedTimestamp,
            structuralStatus: true,
            verificationProof: bytes32(0),
            subjectId: incidentId
        });

        isSubjectConflicted[incidentId] = true;
        emit IncidentLogged(assignedId, incidentId, compressedTimestamp);
    }

    function isConflicted(address /* reviewer */, bytes32 subjectId) external view returns (bool) {
        return isSubjectConflicted[subjectId];
    }

    function declareConflict(bytes32 subjectId, bytes32 proof, uint256 /* classification */) external returns (uint256 conflictId) {
        conflictId = declareIncident(subjectId);
        incidents[conflictId].verificationProof = proof;
        // Fixed: Emit tracking indicator event for off-chain metrics visibility
        emit ConflictProofAttached(conflictId, proof);
    }

    function revokeConflict(uint256 conflictId) external {
        require(msg.sender == administrativeSteward, "Not administrative steward");
        require(incidents[conflictId].structuralStatus, "Incident does not exist or is inactive");
        
        incidents[conflictId].structuralStatus = false;
        bytes32 subject = incidents[conflictId].subjectId;
        isSubjectConflicted[subject] = false;
        
        emit IncidentRevoked(conflictId, subject);
    }
}
