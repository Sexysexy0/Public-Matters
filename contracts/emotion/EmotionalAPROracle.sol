// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EmotionalAPROracle {
    struct EmotionalPing {
        uint256 griefIndex; // 0–100
        uint256 joyIndex;   // 0–100
        string region;
        string sourceTag;   // e.g. "Scroll", "MediaFeed", "BarangayPulse"
        uint256 timestamp;
    }

    EmotionalPing[] public pings;
    address public steward;

    event EmotionalPingLogged(string region, string sourceTag, uint256 griefIndex, uint256 joyIndex);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized emotional caster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logEmotionalPing(
        uint256 _griefIndex,
        uint256 _joyIndex,
        string memory _region,
        string memory _sourceTag
    ) external onlySteward {
        pings.push(EmotionalPing(_griefIndex, _joyIndex, _region, _sourceTag, block.timestamp));
        emit EmotionalPingLogged(_region, _sourceTag, _griefIndex, _joyIndex);
    }

    function getPing(uint256 _id) external view returns (EmotionalPing memory) {
        return pings[_id];
    }

    function totalPings() external view returns (uint256) {
        return pings.length;
    }
}
