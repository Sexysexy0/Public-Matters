// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnifiedTradeLicense {
    enum Nation { Korea, Japan, India, Taiwan, Singapore }
    enum LicenseStatus { Pending, Approved, Revoked }

    struct TradeLicense {
        uint256 id;
        string entityName;
        Nation nation;
        string goodsCategory;
        uint256 issueDate;
        LicenseStatus status;
    }

    mapping(uint256 => TradeLicense) public licenseRegistry;
    uint256 public licenseCount;

    event LicenseIssued(uint256 id, string entityName, Nation nation);
    event LicenseRevoked(uint256 id);

    function issueLicense(
        string memory entityName,
        Nation nation,
        string memory goodsCategory,
        uint256 issueDate
    ) public {
        licenseRegistry[licenseCount] = TradeLicense(
            licenseCount,
            entityName,
            nation,
            goodsCategory,
            issueDate,
            LicenseStatus.Approved
        );
        emit LicenseIssued(licenseCount, entityName, nation);
        licenseCount++;
    }

    function revokeLicense(uint256 id) public {
        require(id < licenseCount, "Invalid license ID");
        licenseRegistry[id].status = LicenseStatus.Revoked;
        emit LicenseRevoked(id);
    }

    function getLicense(uint256 id) public view returns (TradeLicense memory) {
        return licenseRegistry[id];
    }
}
