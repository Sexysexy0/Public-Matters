pragma solidity ^0.8.20;

contract PowerAbuseProtocol {
    address public admin;

    struct Abuse {
        string character;    // e.g. Homelander, supes
        string typeOf;       // e.g. corruption, prioritizing image over lives
        string impact;       // e.g. public deception, systemic harm
        uint256 timestamp;
    }

    Abuse[] public abuses;

    event AbuseLogged(string character, string typeOf, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAbuse(string calldata character, string calldata typeOf, string calldata impact) external onlyAdmin {
        abuses.push(Abuse(character, typeOf, impact, block.timestamp));
        emit AbuseLogged(character, typeOf, impact, block.timestamp);
    }

    function totalAbuses() external view returns (uint256) {
        return abuses.length;
    }
}
