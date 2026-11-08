// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title ExtractivePermitRegistry
 * @notice On-chain registry for mining and extractive permits.
 *         Forces the issuer to be publicly identifiable.
 */
contract ExtractivePermitRegistry {
    OperatorPrivileges public immutable privileges;

    struct Permit {
        bytes32 companyHash;
        bytes32 locationHash;
        bytes32 eccHash;        // Environmental Compliance Certificate hash
        address issuer;         // The government official who signed it
        uint256 startDate;
        uint256 endDate;
        bool active;
    }

    mapping(bytes32 => Permit) public permits;
    mapping(bytes32 => bytes32[]) public permitsByLocation;
    
    event PermitIssued(bytes32 indexed permitId, bytes32 indexed companyHash, address indexed issuer, uint256 endDate);
    event PermitRevoked(bytes32 indexed permitId, address indexed revokedBy, string reason);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function issuePermit(
        bytes32 permitId,
        bytes32 companyHash,
        bytes32 locationHash,
        bytes32 eccHash,
        uint256 duration
    ) external onlyOperator {
        require(permits[permitId].issuer == address(0), "Permit exists");

        permits[permitId] = Permit({
            companyHash: companyHash,
            locationHash: locationHash,
            eccHash: eccHash,
            issuer: msg.sender, // Ikaw ang opisyal na pumirma, naka-record habambuhay
            startDate: block.timestamp,
            endDate: block.timestamp + duration,
            active: true
        });

        permitsByLocation[locationHash].push(permitId);
        emit PermitIssued(permitId, companyHash, msg.sender, block.timestamp + duration);
    }

    function revokePermit(bytes32 permitId, string calldata reason) external onlyOperator {
        require(permits[permitId].active, "Permit inactive");
        permits[permitId].active = false;
        emit PermitRevoked(permitId, msg.sender, reason);
    }

    function getPermit(bytes32 permitId) external view returns (Permit memory) {
        return permits[permitId];
    }

    function isPermitValid(bytes32 permitId) external view returns (bool) {
        Permit memory p = permits[permitId];
        return p.active && block.timestamp <= p.endDate;
    }
}
