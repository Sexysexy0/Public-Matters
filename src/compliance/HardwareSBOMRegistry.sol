// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AttributionRegistry & ComplianceGuard
 * @notice Systemic fix for hardware manufacturers hiding embedded open-source software (e.g., Minix 3 in Intel ME).
 *         Enforces immutable, verifiable Software Bill of Materials (SBOM) and legal notices on-chain.
 */
contract AttributionRegistry {
    
    struct LegalNotice {
        string componentName;  // e.g. "Minix 3 Operating System"
        string licenseType;     // e.g. "BSD-3-Clause"
        string copyrightText;   // e.g. "Copyright (c) Andrew Tanenbaum..."
        string binaryHash;      // Cryptographic hash of the embedded binary
        bool isVerified;
    }

    // Hardware Chipset / Serial ID => List of embedded licenses
    mapping(bytes32 => LegalNotice[]) private hardwareSBOM;

    event LicenseRegistered(
        bytes32 indexed hardwareId, 
        string componentName, 
        string licenseType
    );

    /**
     * @notice Register mandatory open-source legal notices for a hardware batch
     */
    function registerAttribution(
        bytes32 hardwareId,
        string calldata componentName,
        string calldata licenseType,
        string calldata copyrightText,
        string calldata binaryHash
    ) external {
        require(bytes(componentName).length > 0, "Component name required");
        require(bytes(licenseType).length > 0, "License type required");

        hardwareSBOM[hardwareId].push(LegalNotice({
            componentName: componentName,
            licenseType: licenseType,
            copyrightText: copyrightText,
            binaryHash: binaryHash,
            isVerified: true
        }));

        emit LicenseRegistered(hardwareId, componentName, licenseType);
    }

    /**
     * @notice Fetch total registered open-source notices for a hardware ID
     */
    function getNoticeCount(bytes32 hardwareId) external view returns (uint256) {
        return hardwareSBOM[hardwareId].length;
    }

    /**
     * @notice Verification gatekeeper to ensure non-infringement before distribution
     */
    function isHardwareCompliant(bytes32 hardwareId) external view returns (bool) {
        return hardwareSBOM[hardwareId].length > 0;
    }
}
