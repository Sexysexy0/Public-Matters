pragma solidity ^0.8.20;

contract NuclearLicenseProtocol {
    address public admin;

    struct License {
        string requirement;   // e.g. IAEA compliance, PNRI approval
        string status;        // e.g. pending, approved, rejected
        string authority;     // e.g. PNRI, DOE, IAEA
        uint256 timestamp;
    }

    License[] public licenses;

    event LicenseLogged(string requirement, string status, string authority, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLicense(string calldata requirement, string calldata status, string calldata authority) external onlyAdmin {
        licenses.push(License(requirement, status, authority, block.timestamp));
        emit LicenseLogged(requirement, status, authority, block.timestamp);
    }

    function totalLicenses() external view returns (uint256) {
        return licenses.length;
    }
}
