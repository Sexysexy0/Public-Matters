// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title LocalMaintenanceTrainingRegistry
 * @notice Tracks local operators who have been certified to maintain specific assets (e.g., Water Wells).
 *         Integration: Escrow contracts can check if an operator is certified before releasing funds.
 */
contract LocalMaintenanceTrainingRegistry {
    OperatorPrivileges public immutable privileges;

    struct Certification {
        bytes32 assetTypeHash; // e.g., "Water Well Pump"
        address trainer;       // The certified trainer/instructor
        uint256 issuedAt;
        bool valid;
    }

    // operatorAddress => assetTypeHash => Certification
    mapping(address => mapping(bytes32 => Certification)) public certifications;

    event TrainerCertified(address indexed trainer, bytes32 assetTypeHash);
    event OperatorCertified(address indexed operator, bytes32 assetTypeHash, address indexed trainer);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    /**
     * @notice An operator registers themselves as a certified trainer for a specific asset.
     */
    function registerTrainer(bytes32 assetTypeHash) external onlyOperator {
        certifications[msg.sender][assetTypeHash] = Certification({
            assetTypeHash: assetTypeHash,
            trainer: msg.sender,
            issuedAt: block.timestamp,
            valid: true
        });
        emit TrainerCertified(msg.sender, assetTypeHash);
    }

    /**
     * @notice A certified trainer issues a certificate to a local operator.
     */
    function certifyLocalOperator(address localOperator, bytes32 assetTypeHash) external onlyOperator {
        require(certifications[msg.sender][assetTypeHash].valid, "Not a valid trainer for this asset");
        
        certifications[localOperator][assetTypeHash] = Certification({
            assetTypeHash: assetTypeHash,
            trainer: msg.sender,
            issuedAt: block.timestamp,
            valid: true
        });
        
        emit OperatorCertified(localOperator, assetTypeHash, msg.sender);
    }

    function isCertified(address localOperator, bytes32 assetTypeHash) external view returns (bool) {
        return certifications[localOperator][assetTypeHash].valid;
    }
}
