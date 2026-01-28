pragma solidity ^0.8.20;

contract HardwareDependencyProtocol {
    address public admin;

    struct Dependency {
        string company;      // e.g. AI startup
        string hardware;     // e.g. GPUs, TPUs
        string risk;         // e.g. monopoly reliance, bottleneck
        uint256 timestamp;
    }

    Dependency[] public dependencies;

    event DependencyLogged(string company, string hardware, string risk, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDependency(string calldata company, string calldata hardware, string calldata risk) external onlyAdmin {
        dependencies.push(Dependency(company, hardware, risk, block.timestamp));
        emit DependencyLogged(company, hardware, risk, block.timestamp);
    }

    function totalDependencies() external view returns (uint256) {
        return dependencies.length;
    }
}
