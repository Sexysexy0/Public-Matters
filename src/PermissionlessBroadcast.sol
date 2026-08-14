// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract PermissionlessBroadcast {
    ITrustIntegrator public trustIntegrator;
    address public steward;

    event BroadcastSent(address indexed broadcaster, string content);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _trustIntegrator) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function broadcast(string calldata content) external {
        trustIntegrator.logPositiveAction(
            string(abi.encodePacked("Broadcast: ", content)),
            10
        );
        emit BroadcastSent(msg.sender, content);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}
