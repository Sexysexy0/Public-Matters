// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EducationSupportCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of education support safeguards
contract EducationSupportCodex {
    address public overseer;
    uint256 public supportCount;

    struct SupportEntry {
        uint256 id;
        string child;
        string guardian;
        string dimension;
        uint256 timestamp;
    }

    mapping(uint256 => SupportEntry) public supports;

    event SupportLogged(uint256 indexed id, string child, string guardian, string dimension);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSupport(
        string calldata child,
        string calldata guardian,
        string calldata dimension
    ) external onlyOverseer {
        supportCount++;
        supports[supportCount] = SupportEntry({
            id: supportCount,
            child: child,
            guardian: guardian,
            dimension: dimension,
            timestamp: block.timestamp
        });
        emit SupportLogged(supportCount, child, guardian, dimension);
    }

    function viewSupport(uint256 id) external view returns (SupportEntry memory) {
        return supports[id];
    }
}
