// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmergencyForkCodex {
    address public steward;

    struct ForkEntry {
        string chainName;
        string forkReason;
        string forkOutcome;
        string emotionalTag;
    }

    ForkEntry[] public codex;

    event EmergencyForkLogged(string chainName, string forkReason, string forkOutcome, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function logFork(
        string memory chainName,
        string memory forkReason,
        string memory forkOutcome,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ForkEntry(chainName, forkReason, forkOutcome, emotionalTag));
        emit EmergencyForkLogged(chainName, forkReason, forkOutcome, emotionalTag);
    }
}
