pragma solidity ^0.8.0;

contract WorkplaceRespectProtocol {
    event RespectAlert(string employee, string issue);

    function reportAbuse(string memory employee, bool abuseDetected) public {
        if (abuseDetected) {
            emit RespectAlert(employee, "Verbal abuse reported – safeguard activated");
        }
    }
}
