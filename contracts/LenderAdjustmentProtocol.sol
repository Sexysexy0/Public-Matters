pragma solidity ^0.8.20;

contract LenderAdjustmentProtocol {
    address public admin;

    struct Adjustment {
        string measure;      // e.g. higher fees, stricter scoring
        string effect;       // e.g. reduced exposure, product redesign
        string target;       // e.g. prime vs subprime customers
        uint256 timestamp;
    }

    Adjustment[] public adjustments;

    event AdjustmentLogged(string measure, string effect, string target, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAdjustment(string calldata measure, string calldata effect, string calldata target) external onlyAdmin {
        adjustments.push(Adjustment(measure, effect, target, block.timestamp));
        emit AdjustmentLogged(measure, effect, target, block.timestamp);
    }

    function totalAdjustments() external view returns (uint256) {
        return adjustments.length;
    }
}
