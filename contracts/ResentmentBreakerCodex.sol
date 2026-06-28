// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ResentmentBreakerCodex
/// @notice Covenant contract to safeguard communities by breaking cycles of resentment
contract ResentmentBreakerCodex {
    address public overseer;
    uint256 public breakerCount;

    struct BreakerEntry {
        uint256 id;
        string actor;
        string method;
        string context;
        uint256 timestamp;
    }

    mapping(uint256 => BreakerEntry) public breakers;

    event BreakerLogged(uint256 indexed id, string actor, string method);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logBreaker(
        string calldata actor,
        string calldata method,
        string calldata context
    ) external onlyOverseer {
        breakerCount++;
        breakers[breakerCount] = BreakerEntry({
            id: breakerCount,
            actor: actor,
            method: method,
            context: context,
            timestamp: block.timestamp
        });
        emit BreakerLogged(breakerCount, actor, method);
    }

    function viewBreaker(uint256 id) external view returns (BreakerEntry memory) {
        return breakers[id];
    }
}
