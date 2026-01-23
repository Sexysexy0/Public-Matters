pragma solidity ^0.8.20;

contract InflationControlProtocol {
    address public admin;

    struct Control {
        string factor;       // e.g. fuel price adjustment
        string mechanism;    // e.g. subsidy, tax relief
        string impact;       // e.g. reduced inflation pressure
        uint256 timestamp;
    }

    Control[] public controls;

    event ControlLogged(string factor, string mechanism, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logControl(string calldata factor, string calldata mechanism, string calldata impact) external onlyAdmin {
        controls.push(Control(factor, mechanism, impact, block.timestamp));
        emit ControlLogged(factor, mechanism, impact, block.timestamp);
    }

    function totalControls() external view returns (uint256) {
        return controls.length;
    }
}
