// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/**
 * @title GlobalAssetRegistry
 * @notice Bitmapped Access Control + EIP-1153 Transient Storage for Global Multi-Tenant Asset Management.
 */
contract GlobalAssetRegistry {
    // Bitmapped Roles
    uint256 public constant ROLE_EMPEROR = 1 << 0; // 1
    uint256 public constant ROLE_STEWARD = 1 << 1; // 2
    uint256 public constant ROLE_AUDITOR = 1 << 2; // 4
    uint256 public constant ROLE_ESCROW_AGENT = 1 << 3; // 8

    enum AssetType {
        RealEstate,
        BusinessHoldings,
        Infrastructure,
        SovereignDebt
    }
    enum AssetStatus {
        Proposed,
        Active,
        Frozen,
        Liquidation
    }

    // Packed Storage Struct (32 + 32 = 64 Bytes total, 2 Storage Slots)
    struct AssetBrick {
        address steward; // 20 bytes
        uint16 countryCode; // 2 bytes
        AssetType assetType; // 1 byte
        AssetStatus status; // 1 byte
        uint8 approvalThreshold; // 1 byte
        uint256 valuation; // 32 bytes
    }

    // Storage Mappings
    mapping(bytes32 => AssetBrick) public assets;
    mapping(address => uint256) public userRoles;

    // Events
    event AssetBrickCreated(bytes32 indexed assetId, AssetType assetType, address indexed steward);
    event AccessMatrixUpdated(address indexed entity, uint256 newRoleBitmap);
    event TransientApprovalRecorded(bytes32 indexed assetId, address indexed approver, uint256 currentCount);
    event ActionExecuted(bytes32 indexed assetId, address target, bool success);

    modifier onlyRole(uint256 roleBit) {
        require((userRoles[msg.sender] & roleBit) != 0, "UNAUTHORIZED_ROLE");
        _;
    }

    constructor() {
        userRoles[msg.sender] = ROLE_EMPEROR;
        emit AccessMatrixUpdated(msg.sender, ROLE_EMPEROR);
    }

    function setEntityRoles(address entity, uint256 roleBitmap) external onlyRole(ROLE_EMPEROR) {
        userRoles[entity] = roleBitmap;
        emit AccessMatrixUpdated(entity, roleBitmap);
    }

    function initializeAssetBrick(
        bytes32 assetId,
        AssetType assetType,
        uint16 countryCode,
        address steward,
        uint8 approvalThreshold,
        uint256 valuation
    ) external onlyRole(ROLE_EMPEROR) {
        require(assets[assetId].steward == address(0), "ASSET_EXISTS");
        require(steward != address(0), "INVALID_STEWARD");

        assets[assetId] = AssetBrick({
            steward: steward,
            countryCode: countryCode,
            assetType: assetType,
            status: AssetStatus.Active,
            approvalThreshold: approvalThreshold,
            valuation: valuation
        });

        emit AssetBrickCreated(assetId, assetType, steward);
    }

    /**
     * @notice Records approval in Transient Storage (EIP-1153 TSTORE).
     * Zero persistent storage overhead—state wipes automatically after transaction execution!
     */
    function recordTransientApproval(bytes32 assetId) external {
        require(userRoles[msg.sender] != 0, "NO_REGISTERED_ROLE");

        bytes32 voterSlot = keccak256(abi.encodePacked("TRANSIENT_VOTE", assetId, msg.sender));
        bytes32 countSlot = keccak256(abi.encodePacked("TRANSIENT_COUNT", assetId));

        uint256 newCount;

        assembly {
            // Revert if voter already approved in this tx
            if eq(tload(voterSlot), 1) {
                mstore(0x00, 0x08c379a0) // Error(string) selector
                mstore(0x04, 0x20)
                mstore(0x24, 13)
                mstore(0x44, "ALREADY_VOTED")
                revert(0x00, 0x68)
            }
            // Mark voter as done for this tx
            tstore(voterSlot, 1)

            // Increment transient vote counter
            let currentCount := tload(countSlot)
            newCount := add(currentCount, 1)
            tstore(countSlot, newCount)
        }

        emit TransientApprovalRecorded(assetId, msg.sender, newCount);
    }

    /**
     * @notice Reads transient votes using TLOAD and dispatches low-level call if threshold is met.
     */
    function validateAndExecute(bytes32 assetId, address target, bytes calldata payload)
        external
        returns (bool success)
    {
        AssetBrick memory brick = assets[assetId];
        require(brick.steward != address(0), "ASSET_NOT_FOUND");
        require(brick.status == AssetStatus.Active, "ASSET_NOT_ACTIVE");

        bytes32 countSlot = keccak256(abi.encodePacked("TRANSIENT_COUNT", assetId));
        uint256 currentApprovals;

        assembly {
            currentApprovals := tload(countSlot)
            // Reset counter within this transaction frame
            tstore(countSlot, 0)
        }

        require(currentApprovals >= brick.approvalThreshold, "INSUFFICIENT_TRANSIENT_APPROVALS");

        (success,) = target.call(payload);
        require(success, "EXECUTION_FAILED");

        emit ActionExecuted(assetId, target, success);
    }

    function getTransientApprovals(bytes32 assetId) external view returns (uint256 count) {
        bytes32 countSlot = keccak256(abi.encodePacked("TRANSIENT_COUNT", assetId));
        assembly {
            count := tload(countSlot)
        }
    }
}
