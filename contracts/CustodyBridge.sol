// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CustodyBridge
/// @notice Covenant contract to safeguard communities through systemic anchoring of custody safeguards
contract CustodyBridge {
    address public overseer;
    uint256 public custodyCount;

    struct CustodyEntry {
        uint256 id;
        string child;
        string custodian;
        string authority;
        uint256 timestamp;
    }

    mapping(uint256 => CustodyEntry) public custodies;

    event CustodyLogged(uint256 indexed id, string child, string custodian, string authority);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logCustody(
        string calldata child,
        string calldata custodian,
        string calldata authority
    ) external onlyOverseer {
        custodyCount++;
        custodies[custodyCount] = CustodyEntry({
            id: custodyCount,
            child: child,
            custodian: custodian,
            authority: authority,
            timestamp: block.timestamp
        });
        emit CustodyLogged(custodyCount, child, custodian, authority);
    }

    function viewCustody(uint256 id) external view returns (CustodyEntry memory) {
        return custodies[id];
    }
}
