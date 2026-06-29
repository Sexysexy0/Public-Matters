// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TrustCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of trust safeguards
contract TrustCodex {
    address public overseer;
    uint256 public trustCount;

    struct TrustEntry {
        uint256 id;
        string actor;
        string beneficiary;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => TrustEntry) public trusts;

    event TrustLogged(uint256 indexed id, string actor, string beneficiary, string principle);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTrust(
        string calldata actor,
        string calldata beneficiary,
        string calldata principle
    ) external onlyOverseer {
        trustCount++;
        trusts[trustCount] = TrustEntry({
            id: trustCount,
            actor: actor,
            beneficiary: beneficiary,
            principle: principle,
            timestamp: block.timestamp
        });
        emit TrustLogged(trustCount, actor, beneficiary, principle);
    }

    function viewTrust(uint256 id) external view returns (TrustEntry memory) {
        return trusts[id];
    }
}
