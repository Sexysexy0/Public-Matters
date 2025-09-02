// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title AgriAuditOracle
/// @dev Ritualizes agricultural audits, performance scoring, and damay clause triggers

contract AgriAuditOracle {
    address public steward;
    mapping(address => uint256) public auditScore;
    mapping(address => string) public emotionalAPR;
    mapping(address => bool) public damayTriggered;

    event AuditLogged(address indexed stewardAddr, uint256 score, string apr);
    event DamayActivated(address indexed stewardAddr, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logAudit(address stewardAddr, uint256 score, string memory apr) public onlySteward {
        auditScore[stewardAddr] = score;
        emotionalAPR[stewardAddr] = apr;
        emit AuditLogged(stewardAddr, score, apr);

        if (score < 60 || keccak256(bytes(apr)) == keccak256(bytes("Grief"))) {
            damayTriggered[stewardAddr] = true;
            emit DamayActivated(stewardAddr, "Low audit score or grief APR detected");
        }
    }

    function getAuditStatus(address stewardAddr) public view returns (uint256, string memory, bool) {
        return (
            auditScore[stewardAddr],
            emotionalAPR[stewardAddr],
            damayTriggered[stewardAddr]
        );
    }
}
