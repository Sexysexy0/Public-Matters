// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EquityCycleOracle {
    struct Cycle {
        address subscriber;
        string tier;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Cycle[] public cycles;

    event CycleLogged(address indexed subscriber, string tier, string safeguard);
    event CycleSafeguarded(uint256 indexed id, address verifier);

    function logCycle(string memory _tier, string memory _safeguard) public {
        cycles.push(Cycle(msg.sender, _tier, _safeguard, block.timestamp, false));
        emit CycleLogged(msg.sender, _tier, _safeguard);
    }

    function safeguardCycle(uint256 _id) public {
        require(_id < cycles.length, "Invalid ID");
        cycles[_id].safeguarded = true;
        emit CycleSafeguarded(_id, msg.sender);
    }

    function getCycle(uint256 _id) public view returns (Cycle memory) {
        require(_id < cycles.length, "Invalid ID");
        return cycles[_id];
    }

    function totalCycles() public view returns (uint256) {
        return cycles.length;
    }
}
