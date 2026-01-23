pragma solidity ^0.8.20;

contract TransportCostProtocol {
    address public admin;

    struct Transport {
        string sector;       // e.g. jeepney, trucking, shipping
        string adjustment;   // e.g. lower diesel price
        string effect;       // e.g. reduced fare, cheaper logistics
        uint256 timestamp;
    }

    Transport[] public transports;

    event TransportLogged(string sector, string adjustment, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTransport(string calldata sector, string calldata adjustment, string calldata effect) external onlyAdmin {
        transports.push(Transport(sector, adjustment, effect, block.timestamp));
        emit TransportLogged(sector, adjustment, effect, block.timestamp);
    }

    function totalTransports() external view returns (uint256) {
        return transports.length;
    }
}
