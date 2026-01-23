pragma solidity ^0.8.20;

contract HUMINTProtocol {
    address public admin;

    struct HUMINT {
        string tactic;       // e.g. planted business partner, social connection
        string objective;    // e.g. gain trust, extract info
        string risk;         // e.g. exposure, manipulation
        uint256 timestamp;
    }

    HUMINT[] public humints;

    event HUMINTLogged(string tactic, string objective, string risk, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logHUMINT(string calldata tactic, string calldata objective, string calldata risk) external onlyAdmin {
        humints.push(HUMINT(tactic, objective, risk, block.timestamp));
        emit HUMINTLogged(tactic, objective, risk, block.timestamp);
    }

    function totalHUMINTs() external view returns (uint256) {
        return humints.length;
    }
}
