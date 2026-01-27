pragma solidity ^0.8.20;

contract BarangayMatchProtocol {
    address public admin;

    struct Match {
        string barangayA;    // e.g. Bangkal
        string barangayB;    // e.g. Northville
        string status;       // e.g. scheduled, finished
        uint256 timestamp;
    }

    Match[] public matches;

    event MatchLogged(string barangayA, string barangayB, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMatch(string calldata barangayA, string calldata barangayB, string calldata status) external onlyAdmin {
        matches.push(Match(barangayA, barangayB, status, block.timestamp));
        emit MatchLogged(barangayA, barangayB, status, block.timestamp);
    }

    function totalMatches() external view returns (uint256) {
        return matches.length;
    }
}
