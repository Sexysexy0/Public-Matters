// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ServiceCodex
/// @notice Covenant contract to safeguard systemic duty, principled service, and dignified stewardship
contract ServiceCodex {
    address public overseer;
    uint256 public serviceCount;

    struct ServiceRule {
        uint256 id;
        string principle; // Duty, Stewardship, Responsibility, Contribution
        string description; // encoded service safeguard
        uint256 timestamp;
    }

    mapping(uint256 => ServiceRule) public services;

    event ServiceLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logService(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        serviceCount++;
        services[serviceCount] = ServiceRule({
            id: serviceCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ServiceLogged(serviceCount, principle, description);
    }

    function viewService(uint256 id) external view returns (ServiceRule memory) {
        return services[id];
    }
}
