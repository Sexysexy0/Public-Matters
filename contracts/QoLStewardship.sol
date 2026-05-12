// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract QoLStewardship {
    struct Update {
        address player;
        string feature;
        uint256 timestamp;
        bool stabilized;
    }

    Update[] public updates;

    event UpdateLogged(address indexed player, string feature);
    event UpdateStabilized(uint256 indexed id, address verifier);

    function logUpdate(string memory _feature) public {
        updates.push(Update(msg.sender, _feature, block.timestamp, false));
        emit UpdateLogged(msg.sender, _feature);
    }

    function stabilizeUpdate(uint256 _id) public {
        require(_id < updates.length, "Invalid ID");
        updates[_id].stabilized = true;
        emit UpdateStabilized(_id, msg.sender);
    }

    function getUpdate(uint256 _id) public view returns (Update memory) {
        require(_id < updates.length, "Invalid ID");
        return updates[_id];
    }

    function totalUpdates() public view returns (uint256) {
        return updates.length;
    }
}
