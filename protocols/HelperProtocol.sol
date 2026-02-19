// HelperProtocol.sol
pragma solidity ^0.8.0;

contract HelperProtocol {
    struct Inquiry {
        uint256 id;
        string applicant;   // e.g. "Applicant A"
        string message;     // e.g. "Resume Submitted"
        string status;      // e.g. "Forwarded", "Reminded"
        uint256 timestamp;
    }

    uint256 public inquiryCount;
    mapping(uint256 => Inquiry) public inquiries;

    event InquiryLogged(uint256 id, string applicant, string message, string status, uint256 timestamp);
    event HelperDeclared(string message);

    function logInquiry(string memory applicant, string memory message, string memory status) public {
        inquiryCount++;
        inquiries[inquiryCount] = Inquiry(inquiryCount, applicant, message, status, block.timestamp);
        emit InquiryLogged(inquiryCount, applicant, message, status, block.timestamp);
    }

    function declareHelper() public {
        emit HelperDeclared("Helper Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
