// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./InstitutionalAuditHistory.sol";
import "./GovernanceSimulation.sol";

contract JointStockGovernanceLedger {
    struct Shareholder {
        uint256 shares;
        bool exists;
    }

    mapping(address => Shareholder) public shareholders;
    uint256 public totalShares;

    InstitutionalAuditHistory public immutable auditLog;
    GovernanceSimulation public immutable governanceSim;

    event SharesIssued(address indexed to, uint256 amount);
    event SharesTransferred(address indexed from, address indexed to, uint256 amount);

    modifier onlyShareholder() {
        require(shareholders[msg.sender].exists, "Not a shareholder");
        _;
    }

    constructor(address _auditLog, address _governanceSim) {
        auditLog = InstitutionalAuditHistory(_auditLog);
        governanceSim = GovernanceSimulation(_governanceSim);
    }

    function issueShares(address to, uint256 amount) external {
        shareholders[to].shares += amount;
        shareholders[to].exists = true;
        totalShares += amount;

        emit SharesIssued(to, amount);

        if (address(auditLog) != address(0)) {
            auditLog.logEvent(msg.sender, "ISSUE_SHARES", abi.encode(to, amount));
        }
        if (address(governanceSim) != address(0)) {
            governanceSim.simulate("ISSUE_SHARES", abi.encode(to, amount));
        }
    }

    function transferShares(address to, uint256 amount) external onlyShareholder {
        require(shareholders[msg.sender].shares >= amount, "Insufficient shares");

        shareholders[msg.sender].shares -= amount;
        shareholders[to].shares += amount;
        shareholders[to].exists = true;

        emit SharesTransferred(msg.sender, to, amount);

        if (address(auditLog) != address(0)) {
            auditLog.logEvent(msg.sender, "TRANSFER_SHARES", abi.encode(to, amount));
        }
        if (address(governanceSim) != address(0)) {
            governanceSim.simulate("TRANSFER_SHARES", abi.encode(msg.sender, to, amount));
        }
    }

    function votingPower(address account) external view returns (uint256) {
        return shareholders[account].shares;
    }
}
