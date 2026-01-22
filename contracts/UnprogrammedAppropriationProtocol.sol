pragma solidity ^0.8.20;

contract UnprogrammedAppropriationProtocol {
    address public admin;

    struct UAProject {
        string project;      // e.g. bleachers, flood control
        uint256 amount;      // e.g. 48000000
        string source;       // e.g. PhilHealth, PDIC
        uint256 timestamp;
    }

    UAProject[] public uaProjects;

    event UAProjectLogged(string project, uint256 amount, string source, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logUAProject(string calldata project, uint256 amount, string calldata source) external onlyAdmin {
        uaProjects.push(UAProject(project, amount, source, block.timestamp));
        emit UAProjectLogged(project, amount, source, block.timestamp);
    }

    function totalUAProjects() external view returns (uint256) {
        return uaProjects.length;
    }
}
