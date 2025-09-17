// SPDX-License-Identifier: SanctumScanner
pragma solidity ^0.8.19;

contract OpenSourceSanctumScanner {
    struct ScanReport {
        address packageID;
        string packageName;
        bool credentialLeakDetected;
        bool wormSignatureDetected;
        string scanNote;
    }

    mapping(address => ScanReport) public scanRegistry;

    event PackageScanned(address packageID, bool credentialLeakDetected);

    function scanPackage(
        address packageID,
        string memory packageName,
        bool credentialLeakDetected,
        bool wormSignatureDetected,
        string memory scanNote
    ) public {
        scanRegistry[packageID] = ScanReport(
            packageID,
            packageName,
            credentialLeakDetected,
            wormSignatureDetected,
            scanNote
        );
        emit PackageScanned(packageID, credentialLeakDetected);
    }

    function getScanStatus(address packageID) public view returns (ScanReport memory) {
        return scanRegistry[packageID];
    }
}
