// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract APRSyncDaemon {
    address public steward;

    struct APRSignal {
        string vendor;
        uint256 emotionalAPR;
        string treatyTag;
        uint256 timestamp;
    }

    APRSignal[] public signals;

    event APRSynced(string vendor, uint256 emotionalAPR, string treatyTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function syncAPR(string memory vendor, uint256 emotionalAPR, string memory treatyTag) external onlySteward {
        signals.push(APRSignal(vendor, emotionalAPR, treatyTag, block.timestamp));
        emit APRSynced(vendor, emotionalAPR, treatyTag);
    }

    function getLatestSignal() external view returns (APRSignal memory) {
        return signals[signals.length - 1];
    }
}
