pragma solidity ^0.8.20;

contract LaborRightsProtocol {
    address public admin;

    struct Right {
        string principle;    // e.g. equal pay for equal work
        string protection;   // e.g. collective bargaining, anti-discrimination
        string outcome;      // e.g. wage fairness, worker dignity
        uint256 timestamp;
    }

    Right[] public rights;

    event RightLogged(string principle, string protection, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRight(string calldata principle, string calldata protection, string calldata outcome) external onlyAdmin {
        rights.push(Right(principle, protection, outcome, block.timestamp));
        emit RightLogged(principle, protection, outcome, block.timestamp);
    }

    function totalRights() external view returns (uint256) {
        return rights.length;
    }
}
