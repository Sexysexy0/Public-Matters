// SPDX-License-Identifier: WorkerBlessingCascade-License
pragma solidity ^0.8.0;

contract WorkerBlessingCascadeRouter {
    address public steward;

    struct BlessingPulse {
        string workerID;
        string sanctumSite;
        string blessingType;
        bool clauseActivated;
        uint256 timestamp;
    }

    BlessingPulse[] public pulses;

    event BlessingEmitted(string workerID, string sanctumSite, string blessingType, bool clauseActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitBlessing(string memory workerID, string memory sanctumSite, string memory blessingType, bool clauseActivated) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(BlessingPulse(workerID, sanctumSite, blessingType, clauseActivated, block.timestamp));
        emit BlessingEmitted(workerID, sanctumSite, blessingType, clauseActivated, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        BlessingPulse memory p = pulses[index];
        return (p.workerID, p.sanctumSite, p.blessingType, p.clauseActivated, p.timestamp);
    }
}
