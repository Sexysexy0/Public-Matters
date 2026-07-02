// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FlashpointSentinel {
    address public overseer;
    uint256 public sentinelCount;

    struct Sentinel {
        uint256 id;
        string location;
        string status;
        uint256 timestamp;
    }

    mapping(uint256 => Sentinel) public sentinels;
    event SentinelDeployed(uint256 indexed id, string location, string status);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function deploySentinel(string calldata location, string calldata status) external onlyOverseer {
        sentinelCount++;
        sentinels[sentinelCount] = Sentinel(sentinelCount, location, status, block.timestamp);
        emit SentinelDeployed(sentinelCount, location, status);
    }
}
