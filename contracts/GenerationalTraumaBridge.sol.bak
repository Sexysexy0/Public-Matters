// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GenerationalTraumaBridge {
    struct Trauma {
        address participant;
        string origin;
        uint256 timestamp;
        bool healed;
    }

    Trauma[] public traumas;

    event TraumaLogged(address indexed participant, string origin);
    event TraumaHealed(uint256 indexed id, address healer);

    function logTrauma(string memory _origin) public {
        traumas.push(Trauma(msg.sender, _origin, block.timestamp, false));
        emit TraumaLogged(msg.sender, _origin);
    }

    function healTrauma(uint256 _id) public {
        require(_id < traumas.length, "Invalid ID");
        traumas[_id].healed = true;
        emit TraumaHealed(_id, msg.sender);
    }

    function getTrauma(uint256 _id) public view returns (Trauma memory) {
        require(_id < traumas.length, "Invalid ID");
        return traumas[_id];
    }

    function totalTraumas() public view returns (uint256) {
        return traumas.length;
    }
}
