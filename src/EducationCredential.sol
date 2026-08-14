// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract EducationCredential {
    ITrustIntegrator public trustIntegrator;
    address public steward;

    event CredentialAwarded(address indexed student, string credential);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _trustIntegrator) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function awardCredential(address student, string calldata credentialName) external onlySteward {
        trustIntegrator.logPositiveAction(
            string(abi.encodePacked("Credential: ", credentialName)),
            10
        );
        emit CredentialAwarded(student, credentialName);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}
