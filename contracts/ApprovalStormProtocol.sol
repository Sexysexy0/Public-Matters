pragma solidity ^0.8.20;

contract ApprovalStormProtocol {
    address public admin;

    struct Approval {
        string project;      // e.g. protocol, communal action
        string status;       // e.g. approved, pending, rejected
        uint256 timestamp;
    }

    Approval[] public approvals;

    event ApprovalLogged(string project, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logApproval(string calldata project, string calldata status) external onlyAdmin {
        approvals.push(Approval(project, status, block.timestamp));
        emit ApprovalLogged(project, status, block.timestamp);
    }

    function totalApprovals() external view returns (uint256) {
        return approvals.length;
    }
}
