pragma solidity ^0.8.20;

contract ReligiousControlProtocol {
    address public admin;

    struct Control {
        string clergy;       // e.g. Catholic priests, bishops
        string regulation;   // e.g. centralized passport storage
        string effect;       // e.g. restricted travel, political integration
        uint256 timestamp;
    }

    Control[] public controls;

    event ControlLogged(string clergy, string regulation, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logControl(string calldata clergy, string calldata regulation, string calldata effect) external onlyAdmin {
        controls.push(Control(clergy, regulation, effect, block.timestamp));
        emit ControlLogged(clergy, regulation, effect, block.timestamp);
    }

    function totalControls() external view returns (uint256) {
        return controls.length;
    }
}
