// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReleaseSupportCodex {
    address public overseer;
    uint256 public supportCount;

    struct SupportRule {
        uint256 id;
        string principle; // Patch Management, Live Ops, Player Support, Long-Term Stability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SupportRule) public supports;

    event SupportLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSupport(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        supportCount++;
        supports[supportCount] = SupportRule({
            id: supportCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit SupportLogged(supportCount, principle, description);
    }

    function viewSupport(uint256 id) external view returns (SupportRule memory) {
        return supports[id];
    }
}
