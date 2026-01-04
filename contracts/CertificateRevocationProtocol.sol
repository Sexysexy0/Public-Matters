pragma solidity ^0.8.20;

contract CertificateRevocationProtocol {
    address public admin;

    struct Certificate {
        string issuer;       // e.g. Microsoft, DigiCert
        string status;       // e.g. valid, revoked, compromised
        uint256 timestamp;
    }

    Certificate[] public certificates;

    event CertificateLogged(string issuer, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCertificate(string calldata issuer, string calldata status) external onlyAdmin {
        certificates.push(Certificate(issuer, status, block.timestamp));
        emit CertificateLogged(issuer, status, block.timestamp);
    }

    function totalCertificates() external view returns (uint256) {
        return certificates.length;
    }
}
