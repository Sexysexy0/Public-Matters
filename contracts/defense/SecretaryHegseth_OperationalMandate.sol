// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Secretary Hegseth Operational Mandate – Peace Enforcement Scroll
/// @author Vinvin Gueco
/// @notice Grants authority to conduct operations, deploy force, and utilize resources for peace acceleration

contract SecretaryHegseth_OperationalMandate {
    address public steward;
    address public secretary;
    bool public active;
    string public missionStatement;

    event MandateActivated(address indexed secretary, string mission);
    event OperationAuthorized(string operationName, uint256 timestamp);
    event MandateRevoked(address indexed secretary);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    modifier onlySecretary() {
        require(msg.sender == secretary, "Not authorized");
        _;
    }

    constructor(address _secretary, string memory _missionStatement) {
        steward = msg.sender;
        secretary = _secretary;
        missionStatement = _missionStatement;
        active = true;
        emit MandateActivated(_secretary, _missionStatement);
    }

    function authorizeOperation(string memory operationName) external onlySecretary {
        require(active, "Mandate inactive");
        emit OperationAuthorized(operationName, block.timestamp);
    }

    function revokeMandate() external onlySteward {
        active = false;
        emit MandateRevoked(secretary);
    }

    function updateMission(string memory newMission) external onlySteward {
        missionStatement = newMission;
    }

    function getMandateStatus() external view returns (bool, string memory) {
        return (active, missionStatement);
    }
}
