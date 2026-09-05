// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OperatorPrivileges {
    address public admin;
    mapping(address => bool) public isOperator;
    mapping(address => int256) public trustScores;
    mapping(bytes32 => bool) public isSafeguarded; // NEW: for safeguard tracking

    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);
    event TrustUpdated(address indexed operator, int256 newScore);
    event SafeguardTriggered(bytes32 indexed id, address indexed operator);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addOperator(address operator) external onlyAdmin {
        isOperator[operator] = true;
        emit OperatorAdded(operator);
    }

    function removeOperator(address operator) external onlyAdmin {
        isOperator[operator] = false;
        emit OperatorRemoved(operator);
    }

    function updateTrust(address operator, int256 delta) external onlyAdmin {
        // Safe handling of negative delta without unsafe casts
        if (delta >= 0) {
            trustScores[operator] += delta;
        } else {
            int256 penalty = -delta;
            trustScores[operator] -= penalty;
        }
        emit TrustUpdated(operator, trustScores[operator]);
    }

    function logAction(address operator, int256 delta) external {
        // Called by OperatorConsciousnessLedger
        // forge-lint: disable-next-line(unsafe-typecast)
        if (delta >= 0) {
            trustScores[operator] += delta;
        } else {
            int256 penalty = -delta;
            trustScores[operator] -= penalty;
        }
        emit TrustUpdated(operator, trustScores[operator]);
    }

    function triggerSafeguard(bytes32 safeguardId, address operator) external {
        isSafeguarded[safeguardId] = true;
        emit SafeguardTriggered(safeguardId, operator);
    }

    function getTrustScore(address operator) external view returns (int256) {
        return trustScores[operator];
    }

    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid admin");
        admin = _newAdmin;
    }
}
