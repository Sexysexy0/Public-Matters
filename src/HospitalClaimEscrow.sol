// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract HospitalClaimEscrow {
    ITrustIntegrator public trustIntegrator;
    address public steward;
    uint256 public claimAmount;

    mapping(address => bool) public patients;

    event ClaimProcessed(address indexed patient, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(uint256 _claimAmount, address _trustIntegrator) {
        steward = msg.sender;
        claimAmount = _claimAmount;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function processClaim(address patient) external onlySteward {
        patients[patient] = true;
        trustIntegrator.logPositiveAction(string(abi.encodePacked("Claim: ", patient)), 20);
        emit ClaimProcessed(patient, claimAmount);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}
