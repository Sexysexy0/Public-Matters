// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NvidiaChipLicenseGrant {
    enum Region { UnitedStates, SouthKorea, Japan, Taiwan, India, Singapore }
    enum LicenseStatus { Pending, Approved, Revoked }

    struct ChipLicense {
        uint256 id;
        string licensee;
        Region region;
        string chipModel;
        string usageCategory;
        uint256 issueDate;
        LicenseStatus status;
        string diplomaticTag;
    }

    mapping(uint256 => ChipLicense) public licenseRegistry;
    uint256 public licenseCount;

    event LicenseGranted(uint256 id, string licensee, Region region, string chipModel);
    event LicenseRevoked(uint256 id);

    function grantLicense(
        string memory licensee,
        Region region,
        string memory chipModel,
        string memory usageCategory,
        uint256 issueDate,
        string memory diplomaticTag
    ) public {
        licenseRegistry[licenseCount] = ChipLicense(
            licenseCount,
            licensee,
            region,
            chipModel,
            usageCategory,
            issueDate,
            LicenseStatus.Approved,
            diplomaticTag
        );
        emit LicenseGranted(licenseCount, licensee, region, chipModel);
        licenseCount++;
    }

    function revokeLicense(uint256 id) public {
        require(id < licenseCount, "Invalid license ID");
        licenseRegistry[id].status = LicenseStatus.Revoked;
        emit LicenseRevoked(id);
    }

    function getLicense(uint256 id) public view returns (ChipLicense memory) {
        return licenseRegistry[id];
    }
}
