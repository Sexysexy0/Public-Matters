// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title DynamicFleetComplianceRegistry
 * @notice Prevents outdated hard caps from punishing job creation.
 *         Adjusts the legal fleet limit dynamically based on verified
 *         insurance and compliance bonds.
 */
contract DynamicFleetComplianceRegistry {
    OperatorPrivileges public immutable privileges;

    struct Platform {
        bytes32 platformId;
        string name;
        uint256 baseCap;           // e.g., 17,000
        uint256 currentVerified;   // verified riders
        uint256 complianceBond;    // deposited funds for penalties
        bool active;
    }

    mapping(bytes32 => Platform) public platforms;
    mapping(bytes32 => mapping(address => bool)) public verifiedRiders; // platform => rider
    mapping(bytes32 => uint256) public unregisteredRiders; // pending verification

    event PlatformRegistered(bytes32 indexed platformId, string name, uint256 baseCap);
    event RiderVerified(bytes32 indexed platformId, address indexed rider);
    event CapExpanded(bytes32 indexed platformId, uint256 newCap);
    event PlatformPenalized(bytes32 indexed platformId, uint256 amount, string reason);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function registerPlatform(bytes32 platformId, string calldata name, uint256 baseCap, uint256 bond) external onlyOperator {
        require(platforms[platformId].baseCap == 0, "Platform exists");
        platforms[platformId] = Platform({
            platformId: platformId,
            name: name,
            baseCap: baseCap,
            currentVerified: 0,
            complianceBond: bond,
            active: true
        });
        emit PlatformRegistered(platformId, name, baseCap);
    }

    /// @notice Operator verifies a rider's insurance and compliance.
    /// @dev As more riders are verified, the cap expands automatically.
    function verifyRider(bytes32 platformId, address rider) external onlyOperator {
        Platform storage p = platforms[platformId];
        require(p.active, "Platform inactive");
        require(!verifiedRiders[platformId][rider], "Rider already verified");

        verifiedRiders[platformId][rider] = true;
        p.currentVerified++;

        // DYNAMIC CAP: Every 10,000 verified riders expands the cap by 50,000.
        // This removes arbitrary limits while ensuring compliance.
        uint256 newCap = p.baseCap + (p.currentVerified / 10000) * 50000;
        
        emit RiderVerified(platformId, rider);
        emit CapExpanded(platformId, newCap);
    }

    /// @notice If a platform is caught with unverified (colorum) riders,
    ///         they are penalized from their bond.
    function penalizeUnverifiedRider(bytes32 platformId, uint256 fineAmount) external onlyOperator {
        Platform storage p = platforms[platformId];
        require(p.complianceBond >= fineAmount, "Bond insufficient");
        p.complianceBond -= fineAmount;
        emit PlatformPenalized(platformId, fineAmount, "Unverified rider");
    }

    function getEffectiveCap(bytes32 platformId) external view returns (uint256) {
        Platform memory p = platforms[platformId];
        return p.baseCap + (p.currentVerified / 10000) * 50000;
    }
}
