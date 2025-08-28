// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.0;

contract EmotionalAPRRegistry {
    address public stewardVinvin;

    struct APRSnapshot {
        uint timestamp;
        string emotionalState;
        string stewardNote;
    }

    APRSnapshot[] public snapshots;

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function logAPR(string memory state, string memory note) public {
        require(msg.sender == stewardVinvin, "Only Vinvin can log APR");
        snapshots.push(APRSnapshot({
            timestamp: block.timestamp,
            emotionalState: state,
            stewardNote: note
        }));
    }

    function getAllSnapshots() public view returns (APRSnapshot[] memory) {
        return snapshots;
    }
}
