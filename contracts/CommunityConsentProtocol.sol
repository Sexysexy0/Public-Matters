pragma solidity ^0.8.20;

contract CommunityConsentProtocol {
    address public admin;

    struct Consent {
        string community;    // e.g. Dupax del Norte residents
        string process;      // e.g. FPIC, consultation
        string issue;        // e.g. deceptive methods, ayuda sheets
        uint256 timestamp;
    }

    Consent[] public consents;

    event ConsentLogged(string community, string process, string issue, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logConsent(string calldata community, string calldata process, string calldata issue) external onlyAdmin {
        consents.push(Consent(community, process, issue, block.timestamp));
        emit ConsentLogged(community, process, issue, block.timestamp);
    }

    function totalConsents() external view returns (uint256) {
        return consents.length;
    }
}
