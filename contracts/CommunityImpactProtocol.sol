pragma solidity ^0.8.20;

contract CommunityImpactProtocol {
    address public admin;

    struct Impact {
        string project;      // e.g. housing, skills training, small business financing
        string outcome;      // e.g. inclusive growth, stability
        uint256 timestamp;
    }

    Impact[] public impacts;

    event ImpactLogged(string project, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logImpact(string calldata project, string calldata outcome) external onlyAdmin {
        impacts.push(Impact(project, outcome, block.timestamp));
        emit ImpactLogged(project, outcome, block.timestamp);
    }

    function totalImpacts() external view returns (uint256) {
        return impacts.length;
    }
}
