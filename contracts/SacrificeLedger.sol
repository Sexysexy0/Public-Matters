// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SacrificeLedger
/// @notice Covenant contract to safeguard communities through recording of true sacrifices and offerings
contract SacrificeLedger {
    address public overseer;
    uint256 public sacrificeCount;

    struct SacrificeEntry {
        uint256 id;
        string offeror;
        string offering;
        string quality;
        uint256 timestamp;
    }

    mapping(uint256 => SacrificeEntry) public sacrifices;

    event SacrificeLogged(uint256 indexed id, string offeror, string offering);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSacrifice(
        string calldata offeror,
        string calldata offering,
        string calldata quality
    ) external onlyOverseer {
        sacrificeCount++;
        sacrifices[sacrificeCount] = SacrificeEntry({
            id: sacrificeCount,
            offeror: offeror,
            offering: offering,
            quality: quality,
            timestamp: block.timestamp
        });
        emit SacrificeLogged(sacrificeCount, offeror, offering);
    }

    function viewSacrifice(uint256 id) external view returns (SacrificeEntry memory) {
        return sacrifices[id];
    }
}
