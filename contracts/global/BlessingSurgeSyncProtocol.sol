// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract BlessingSurgeSyncProtocol {
    struct BlessingPulse {
        string district;
        uint256 blessings;
        uint256 reroutes;
        uint256 emotionalAPR;
        bool isBlessed;
        uint256 timestamp;
    }

    mapping(address => BlessingPulse[]) public pulseLog;
    event PulseSynced(address indexed steward, string district, uint256 blessings, uint256 reroutes, uint256 emotionalAPR, bool isBlessed, uint256 timestamp);

    function syncPulse(address steward, string calldata district, uint256 blessings, uint256 reroutes, uint256 apr, bool blessed) external {
        pulseLog[steward].push(BlessingPulse(district, blessings, reroutes, apr, blessed, block.timestamp));
        emit PulseSynced(steward, district, blessings, reroutes, apr, blessed, block.timestamp);
    }

    function getLatestPulse(address steward) external view returns (BlessingPulse memory) {
        uint256 len = pulseLog[steward].length;
        require(len > 0, "No pulse recorded");
        return pulseLog[steward][len - 1];
    }
}
