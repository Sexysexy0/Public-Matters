// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InfrastructureFreezeRecoveryProtocol {
    address public steward;

    struct RecoveryEntry {
        string region;
        string freezeCause;
        string recoveryMechanism;
        string emotionalTag;
    }

    RecoveryEntry[] public protocol;

    event InfrastructureRecoveryTagged(string region, string freezeCause, string recoveryMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagRecovery(
        string memory region,
        string memory freezeCause,
        string memory recoveryMechanism,
        string memory emotionalTag
    ) public onlySteward {
        protocol.push(RecoveryEntry(region, freezeCause, recoveryMechanism, emotionalTag));
        emit InfrastructureRecoveryTagged(region, freezeCause, recoveryMechanism, emotionalTag);
    }
}
