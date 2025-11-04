// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProofOfReservesTrustCodex {
    address public steward;

    struct PoREntry {
        string exchangeName;
        string auditMethod;
        string trustSignal;
        string emotionalTag;
    }

    PoREntry[] public codex;

    event ProofOfReservesTagged(string exchangeName, string auditMethod, string trustSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagPoR(
        string memory exchangeName,
        string memory auditMethod,
        string memory trustSignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(PoREntry(exchangeName, auditMethod, trustSignal, emotionalTag));
        emit ProofOfReservesTagged(exchangeName, auditMethod, trustSignal, emotionalTag);
    }
}
