pragma solidity ^0.8.20;

contract TravelFreedomProtocol {
    address public admin;

    struct Freedom {
        string traveler;     // e.g. OFW, tourist
        string barrier;      // e.g. offloading, excessive questioning
        string right;        // e.g. freedom of movement
        uint256 timestamp;
    }

    Freedom[] public freedoms;

    event FreedomLogged(string traveler, string barrier, string right, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFreedom(string calldata traveler, string calldata barrier, string calldata right) external onlyAdmin {
        freedoms.push(Freedom(traveler, barrier, right, block.timestamp));
        emit FreedomLogged(traveler, barrier, right, block.timestamp);
    }

    function totalFreedoms() external view returns (uint256) {
        return freedoms.length;
    }
}
