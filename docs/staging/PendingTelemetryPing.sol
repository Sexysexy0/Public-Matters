// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PendingTelemetryPing {
    struct TelemetryPing {
        string region;
        string source;
        uint256 griefIndex;
        uint256 joyIndex;
        bool synced;
        uint256 timestamp;
    }

    TelemetryPing[] public pings;
    address public steward;

    event PingLogged(string region, string source, uint256 griefIndex, uint256 joyIndex);

    constructor() {
        steward = msg.sender;
    }

    function logPing(
        string memory region,
        string memory source,
        uint256 grief,
        uint256 joy
    ) external {
        require(msg.sender == steward, "Unauthorized steward");

        pings.push(TelemetryPing(region, source, grief, joy, false, block.timestamp));
        emit PingLogged(region, source, grief, joy);
    }

    function markSynced(uint256 index) external {
        require(msg.sender == steward, "Unauthorized");
        pings[index].synced = true;
    }

    function getPing(uint256 index) external view returns (TelemetryPing memory) {
        return pings[index];
    }
}
