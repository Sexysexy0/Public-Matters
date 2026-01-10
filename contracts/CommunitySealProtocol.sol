pragma solidity ^0.8.20;

contract CommunitySealProtocol {
    address public admin;

    struct Seal {
        string project;      // e.g. health insurance, transport subsidy
        string approval;     // e.g. communal, validator-grade, pending
        uint256 timestamp;
    }

    Seal[] public seals;

    event SealLogged(string project, string approval, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logSeal(string calldata project, string calldata approval) external onlyAdmin {
        seals.push(Seal(project, approval, block.timestamp));
        emit SealLogged(project, approval, block.timestamp);
    }

    function totalSeals() external view returns (uint256) {
        return seals.length;
    }
}
