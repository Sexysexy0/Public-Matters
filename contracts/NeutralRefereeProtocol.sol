pragma solidity ^0.8.20;

contract NeutralRefereeProtocol {
    address public admin;

    struct Referee {
        string name;         // e.g. Pedro Santos
        string barangay;     // e.g. Neutral barangay assignment
        string role;         // e.g. referee, judge
        uint256 timestamp;
    }

    Referee[] public referees;

    event RefereeLogged(string name, string barangay, string role, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReferee(string calldata name, string calldata barangay, string calldata role) external onlyAdmin {
        referees.push(Referee(name, barangay, role, block.timestamp));
        emit RefereeLogged(name, barangay, role, block.timestamp);
    }

    function totalReferees() external view returns (uint256) {
        return referees.length;
    }
}
