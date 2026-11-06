// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title PropertyMaintenanceRegistry
 * @notice Tracks property cleanliness, zoning violations, and maintenance status.
 *         Allows community to flag "garbage zones" and demand cleanup.
 */
contract PropertyMaintenanceRegistry {
    OperatorPrivileges public immutable privileges;

    enum ZoneStatus { CLEAN, DIRTY, VIOLATION, UNDER_REPAIR }

    struct Property {
        bytes32 id;
        bytes32 ownerHash;
        bytes32 coordinateHash;
        ZoneStatus status;
        uint256 reportsCount;
        uint256 lastCleaned;
        uint256 fineAmount;
    }

    mapping(bytes32 => Property) public properties;
    mapping(bytes32 => mapping(address => bool)) public hasReported;

    event PropertyRegistered(bytes32 indexed propertyId, bytes32 coordinateHash);
    event StatusUpdated(bytes32 indexed propertyId, ZoneStatus status);
    event PropertyReported(bytes32 indexed propertyId, address reporter);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function registerProperty(bytes32 propertyId, bytes32 ownerHash, bytes32 coordinateHash) external onlyOperator {
        require(properties[propertyId].lastCleaned == 0, "Property exists");
        properties[propertyId] = Property({
            id: propertyId,
            ownerHash: ownerHash,
            coordinateHash: coordinateHash,
            status: ZoneStatus.CLEAN,
            reportsCount: 0,
            lastCleaned: block.timestamp,
            fineAmount: 0
        });
        emit PropertyRegistered(propertyId, coordinateHash);
    }

    /// @notice Anyone can report a dirty property.
    function reportDirtyProperty(bytes32 propertyId) external {
        Property storage p = properties[propertyId];
        require(p.lastCleaned != 0, "Property not found");
        require(!hasReported[propertyId][msg.sender], "Already reported");
        
        hasReported[propertyId][msg.sender] = true;
        p.reportsCount++;

        // If enough reports, set to DIRTY
        if (p.reportsCount >= 3 && p.status == ZoneStatus.CLEAN) {
            p.status = ZoneStatus.DIRTY;
            emit StatusUpdated(propertyId, ZoneStatus.DIRTY);
        }

        emit PropertyReported(propertyId, msg.sender);
    }

    function updateStatus(bytes32 propertyId, ZoneStatus newStatus, uint256 fine) external onlyOperator {
        Property storage p = properties[propertyId];
        require(p.lastCleaned != 0, "Property not found");
        
        p.status = newStatus;
        p.fineAmount = fine;
        if (newStatus == ZoneStatus.CLEAN) {
            p.lastCleaned = block.timestamp;
            p.reportsCount = 0;
        }
        emit StatusUpdated(propertyId, newStatus);
    }
}
