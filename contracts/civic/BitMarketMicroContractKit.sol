// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketMicroContractKit {
    struct Worker {
        string name;
        uint completedMilestones;
        uint totalEarned;
    }

    mapping(string => Worker) public workers;

    event MilestoneLogged(string name, uint milestoneReward);

    function logMilestone(string memory name, uint reward) public {
        workers[name].name = name;
        workers[name].completedMilestones++;
        workers[name].totalEarned += reward;
        emit MilestoneLogged(name, reward);
    }

    function getStatus(string memory name) public view returns (string memory) {
        Worker memory w = workers[name];
        return string(abi.encodePacked(w.name, " has completed ", uint2str(w.completedMilestones), " milestones and earned ₱", uint2str(w.totalEarned)));
    }

    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint j = _i; uint len;
        while (j != 0) { len++; j /= 10; }
        bytes memory bstr = new bytes(len); uint k = len;
        while (_i != 0) { k--; bstr[k] = bytes1(uint8(48 + _i % 10)); _i /= 10; }
        return string(bstr);
    }
}
