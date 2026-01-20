pragma solidity ^0.8.20;

contract RegionalAirportProtocol {
    address public admin;

    struct Airport {
        string location;     // e.g. Shargo, Davao, Laguindingan, Bohol-Panglao, Caticlan
        string upgrade;      // e.g. modernization, expansion, new facilities
        uint256 timestamp;
    }

    Airport[] public airports;

    event AirportLogged(string location, string upgrade, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAirport(string calldata location, string calldata upgrade) external onlyAdmin {
        airports.push(Airport(location, upgrade, block.timestamp));
        emit AirportLogged(location, upgrade, block.timestamp);
    }

    function totalAirports() external view returns (uint256) {
        return airports.length;
    }
}
