pragma solidity ^0.8.20;

contract PublicConsultationProtocol {
    address public admin;

    struct Consultation {
        string stakeholder;   // e.g. local community, NGO, government agency
        string issue;         // e.g. safety concerns, funding transparency
        string feedback;      // e.g. support, opposition, conditional approval
        uint256 timestamp;
    }

    Consultation[] public consultations;

    event ConsultationLogged(string stakeholder, string issue, string feedback, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logConsultation(string calldata stakeholder, string calldata issue, string calldata feedback) external onlyAdmin {
        consultations.push(Consultation(stakeholder, issue, feedback, block.timestamp));
        emit ConsultationLogged(stakeholder, issue, feedback, block.timestamp);
    }

    function totalConsultations() external view returns (uint256) {
        return consultations.length;
    }
}
