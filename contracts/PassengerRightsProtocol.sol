pragma solidity ^0.8.20;

contract PassengerRightsProtocol {
    address public admin;

    struct Right {
        string passenger;    // e.g. Filipino traveler
        string issue;        // e.g. offloaded despite complete documents
        string consequence;  // e.g. denied flight, financial loss
        uint256 timestamp;
    }

    Right[] public rights;

    event RightLogged(string passenger, string issue, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRight(string calldata passenger, string calldata issue, string calldata consequence) external onlyAdmin {
        rights.push(Right(passenger, issue, consequence, block.timestamp));
        emit RightLogged(passenger, issue, consequence, block.timestamp);
    }

    function totalRights() external view returns (uint256) {
        return rights.length;
    }
}
