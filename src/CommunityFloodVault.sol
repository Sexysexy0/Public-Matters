// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract CommunityFloodVault {
    ITrustIntegrator public trustIntegrator;
    address public steward;

    struct Relief {
        address contractorOrLeader;
        uint256 amount;
        bool executed;
    }

    mapping(uint256 => Relief) public reliefs;
    uint256 public reliefCount;

    event ReliefInitiated(address indexed initiator, uint256 amount);
    event ReliefExecuted(uint256 indexed reliefId);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _trustIntegrator) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function initiateRelief(address contractor, uint256 amount) external onlySteward {
        reliefs[reliefCount] = Relief(contractor, amount, false);
        emit ReliefInitiated(contractor, amount);
        reliefCount++;
    }

    function executeRelief(uint256 reliefId) external onlySteward {
        require(reliefs[reliefId].executed == false, "Already executed");
        reliefs[reliefId].executed = true;
        trustIntegrator.logPositiveAction(string(abi.encodePacked("Relief: ", reliefs[reliefId].contractorOrLeader)), 3);
        emit ReliefExecuted(reliefId);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}
