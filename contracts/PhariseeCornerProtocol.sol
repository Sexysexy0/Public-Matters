pragma solidity ^0.8.20;

contract PhariseeCornerProtocol {
    address public admin;

    struct Corner {
        string opponent;     // e.g. Pharisees
        string tactic;       // e.g. counter-question, moral framing
        string outcome;      // e.g. no-win situation, silence
        uint256 timestamp;
    }

    Corner[] public corners;

    event CornerLogged(string opponent, string tactic, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCorner(string calldata opponent, string calldata tactic, string calldata outcome) external onlyAdmin {
        corners.push(Corner(opponent, tactic, outcome, block.timestamp));
        emit CornerLogged(opponent, tactic, outcome, block.timestamp);
    }

    function totalCorners() external view returns (uint256) {
        return corners.length;
    }
}
