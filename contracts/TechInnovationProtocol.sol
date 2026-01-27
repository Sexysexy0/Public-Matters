pragma solidity ^0.8.20;

contract TechInnovationProtocol {
    address public admin;

    struct Innovation {
        string field;        // e.g. battery, AI, autonomy
        string breakthrough; // e.g. solid-state battery, robotaxi
        string effect;       // e.g. efficiency, adoption boost
        uint256 timestamp;
    }

    Innovation[] public innovations;

    event InnovationLogged(string field, string breakthrough, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInnovation(string calldata field, string calldata breakthrough, string calldata effect) external onlyAdmin {
        innovations.push(Innovation(field, breakthrough, effect, block.timestamp));
        emit InnovationLogged(field, breakthrough, effect, block.timestamp);
    }

    function totalInnovations() external view returns (uint256) {
        return innovations.length;
    }
}
