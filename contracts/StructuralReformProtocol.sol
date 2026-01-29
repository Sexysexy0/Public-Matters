pragma solidity ^0.8.20;

contract StructuralReformProtocol {
    address public admin;

    struct Reform {
        string policy;       // e.g. Land reform, Industrialization
        string status;       // e.g. Blocked, Proposed, Enacted
        uint256 timestamp;
    }

    Reform[] public reforms;

    event ReformLogged(string policy, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReform(string calldata policy, string calldata status) external onlyAdmin {
        reforms.push(Reform(policy, status, block.timestamp));
        emit ReformLogged(policy, status, block.timestamp);
    }

    function totalReforms() external view returns (uint256) {
        return reforms.length;
    }
}
