pragma solidity ^0.8.20;

contract RevenueAdjustmentProtocol {
    address public admin;

    struct Adjustment {
        string authority;    // e.g. government, tax agency
        string measure;      // e.g. excise tax cut, subsidy
        string effect;       // e.g. lower fuel price, reduced revenue
        uint256 timestamp;
    }

    Adjustment[] public adjustments;

    event AdjustmentLogged(string authority, string measure, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAdjustment(string calldata authority, string calldata measure, string calldata effect) external onlyAdmin {
        adjustments.push(Adjustment(authority, measure, effect, block.timestamp));
        emit AdjustmentLogged(authority, measure, effect, block.timestamp);
    }

    function totalAdjustments() external view returns (uint256) {
        return adjustments.length;
    }
}
