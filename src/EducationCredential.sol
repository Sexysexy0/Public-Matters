// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract EducationCredential {
    ITrustIntegrator public trustIntegrator;
    address public steward;

    mapping(address => mapping(string => bool)) public credentials;

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
        require(!credentials[student][credentialName], "Already has credential");
        credentials[student][credentialName] = true;
        
        trustIntegrator.logPositiveAction(
            string(abi.encodePacked("Credential: ", credentialName)),
            10
        );
        emit CredentialAwarded(student, credentialName);
    }

    function hasCredential(address student, string calldata credentialName) external view returns (bool) {
        return credentials[student][credentialName];
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}
