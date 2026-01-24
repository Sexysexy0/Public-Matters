pragma solidity ^0.8.20;

contract CommunityDefenseProtocol {
    address public admin;

    struct Defense {
        string city;         // e.g. Minneapolis, New York
        string method;       // e.g. observation shifts, visibility vests, recruitment
        uint256 participants; // e.g. 4000 defenders
        uint256 timestamp;
    }

    Defense[] public defenses;

    event DefenseLogged(string city, string method, uint256 participants, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDefense(string calldata city, string calldata method, uint256 participants) external onlyAdmin {
        defenses.push(Defense(city, method, participants, block.timestamp));
        emit DefenseLogged(city, method, participants, block.timestamp);
    }

    function totalDefenses() external view returns (uint256) {
        return defenses.length;
    }
}
