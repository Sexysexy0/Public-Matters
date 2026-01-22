pragma solidity ^0.8.20;

contract GlobalMultipolarityProtocol {
    address public admin;

    struct Multipolarity {
        string actor;        // e.g. India, Brazil, Saudi Arabia
        string initiative;   // e.g. third path alliance
        string implication;  // e.g. reduced US dominance, pragmatic cooperation
        uint256 timestamp;
    }

    Multipolarity[] public multipolarities;

    event MultipolarityLogged(string actor, string initiative, string implication, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMultipolarity(string calldata actor, string calldata initiative, string calldata implication) external onlyAdmin {
        multipolarities.push(Multipolarity(actor, initiative, implication, block.timestamp));
        emit MultipolarityLogged(actor, initiative, implication, block.timestamp);
    }

    function totalMultipolarities() external view returns (uint256) {
        return multipolarities.length;
    }
}
