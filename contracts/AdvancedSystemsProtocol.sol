pragma solidity ^0.8.20;

contract AdvancedSystemsProtocol {
    address public admin;

    struct System {
        string tool;         // e.g. AI monitoring, cybersecurity SCADA, waste management tech
        string function;     // e.g. predictive maintenance, intrusion defense
        string benefit;      // e.g. efficiency, resilience
        uint256 timestamp;
    }

    System[] public systems;

    event SystemLogged(string tool, string function, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSystem(string calldata tool, string calldata function, string calldata benefit) external onlyAdmin {
        systems.push(System(tool, function, benefit, block.timestamp));
        emit SystemLogged(tool, function, benefit, block.timestamp);
    }

    function totalSystems() external view returns (uint256) {
        return systems.length;
    }
}
