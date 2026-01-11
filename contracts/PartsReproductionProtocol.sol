pragma solidity ^0.8.20;

contract PartsReproductionProtocol {
    address public admin;

    struct Part {
        string category;     // e.g. PC, motor, car
        string status;       // e.g. reproduced, pending, failed
        uint256 timestamp;
    }

    Part[] public parts;

    event PartLogged(string category, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPart(string calldata category, string calldata status) external onlyAdmin {
        parts.push(Part(category, status, block.timestamp));
        emit PartLogged(category, status, block.timestamp);
    }

    function totalParts() external view returns (uint256) {
        return parts.length;
    }
}
