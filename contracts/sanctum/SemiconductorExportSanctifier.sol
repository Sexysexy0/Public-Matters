// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SemiconductorExportSanctifier {
    enum Region { UnitedStates, Philippines, China, India, Japan, SouthKorea, EU }
    enum LicenseStatus { Pending, Approved, Revoked }

    struct ExportLicense {
        uint256 id;
        Region origin;
        Region destination;
        string chipType;
        string fabOrigin;
        string complianceTag;
        LicenseStatus status;
        string diplomaticClause;
        uint256 issueDate;
    }

    mapping(uint256 => ExportLicense) public licenseRegistry;
    uint256 public licenseCount;

    event LicenseIssued(uint256 id, Region origin, Region destination, string chipType);
    event LicenseRevoked(uint256 id);
    event LicenseApproved(uint256 id);

    function issueLicense(
        Region origin,
        Region destination,
        string memory chipType,
        string memory fabOrigin,
        string memory complianceTag,
        string memory diplomaticClause,
        uint256 issueDate
    ) public {
        licenseRegistry[licenseCount] = ExportLicense(
            licenseCount,
            origin,
            destination,
            chipType,
            fabOrigin,
            complianceTag,
            LicenseStatus.Pending,
            diplomaticClause,
            issueDate
        );
        emit LicenseIssued(licenseCount, origin, destination, chipType);
        licenseCount++;
    }

    function approveLicense(uint256 id) public {
        require(id < licenseCount, "Invalid license ID");
        licenseRegistry[id].status = LicenseStatus.Approved;
        emit LicenseApproved(id);
    }

    function revokeLicense(uint256 id) public {
        require(id < licenseCount, "Invalid license ID");
        licenseRegistry[id].status = LicenseStatus.Revoked;
        emit LicenseRevoked(id);
    }

    function getLicense(uint256 id) public view returns (ExportLicense memory) {
        return licenseRegistry[id];
    }
}
