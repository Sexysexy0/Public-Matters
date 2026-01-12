pragma solidity ^0.8.20;

contract CasualtyLogProtocol {
    address public admin;

    struct Casualty {
        string event;        // e.g. protest, conflict, communal struggle
        uint256 count;       // number of casualties
        uint256 timestamp;
    }

    Casualty[] public casualties;

    event CasualtyLogged(string event, uint256 count, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCasualty(string calldata event, uint256 count) external onlyAdmin {
        casualties.push(Casualty(event, count, block.timestamp));
        emit CasualtyLogged(event, count, block.timestamp);
    }

    function totalCasualties() external view returns (uint256) {
        return casualties.length;
    }
}
