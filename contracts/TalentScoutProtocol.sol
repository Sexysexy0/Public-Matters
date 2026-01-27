pragma solidity ^0.8.20;

contract TalentScoutProtocol {
    address public admin;

    struct Scout {
        string barangay;     // e.g. Bangkal
        string boxer;        // e.g. Juan Dela Cruz
        string potential;    // e.g. future amateur champ
        uint256 timestamp;
    }

    Scout[] public scouts;

    event ScoutLogged(string barangay, string boxer, string potential, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logScout(string calldata barangay, string calldata boxer, string calldata potential) external onlyAdmin {
        scouts.push(Scout(barangay, boxer, potential, block.timestamp));
        emit ScoutLogged(barangay, boxer, potential, block.timestamp);
    }

    function totalScouts() external view returns (uint256) {
        return scouts.length;
    }
}
