pragma solidity ^0.8.20;

contract VerificationLayerProtocol {
    address public admin;

    struct Verification {
        string reportId;     // Reference to AI report
        string verifier;     // Human team or independent AI
        string status;       // e.g. Verified, Disputed
        uint256 timestamp;
    }

    Verification[] public verifications;

    event VerificationLogged(string reportId, string verifier, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logVerification(string calldata reportId, string calldata verifier, string calldata status) external onlyAdmin {
        verifications.push(Verification(reportId, verifier, status, block.timestamp));
        emit VerificationLogged(reportId, verifier, status, block.timestamp);
    }

    function totalVerifications() external view returns (uint256) {
        return verifications.length;
    }
}
