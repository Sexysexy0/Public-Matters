// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title CloudImpersonationOracle
/// @dev Detects domain mimicry, grief-tagged infrastructure, and impersonation attempts

contract CloudImpersonationOracle {
    address public steward;
    mapping(string => bool) public flaggedDomains;
    mapping(string => string) public emotionalAPR;
    mapping(string => uint256) public timestamp;

    event DomainFlagged(string domain, string apr, uint256 timestamp);
    event DomainCleared(string domain);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function flagDomain(string memory domain, string memory apr) public onlySteward {
        flaggedDomains[domain] = true;
        emotionalAPR[domain] = apr;
        timestamp[domain] = block.timestamp;
        emit DomainFlagged(domain, apr, block.timestamp);
    }

    function clearDomain(string memory domain) public onlySteward {
        flaggedDomains[domain] = false;
        emotionalAPR[domain] = "Hope";
        emit DomainCleared(domain);
    }

    function getDomainStatus(string memory domain) public view returns (bool, string memory, uint256) {
        return (
            flaggedDomains[domain],
            emotionalAPR[domain],
            timestamp[domain]
        );
    }
}
