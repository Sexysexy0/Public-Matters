// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LegendaryMountsBridge {
    struct Mount {
        address tamer;
        string species;
        uint256 timestamp;
        bool safeguarded;
    }

    Mount[] public mounts;

    event MountLogged(address indexed tamer, string species);
    event MountSafeguarded(uint256 indexed id, address verifier);

    function logMount(string memory _species) public {
        mounts.push(Mount(msg.sender, _species, block.timestamp, false));
        emit MountLogged(msg.sender, _species);
    }

    function safeguardMount(uint256 _id) public {
        require(_id < mounts.length, "Invalid ID");
        mounts[_id].safeguarded = true;
        emit MountSafeguarded(_id, msg.sender);
    }

    function getMount(uint256 _id) public view returns (Mount memory) {
        require(_id < mounts.length, "Invalid ID");
        return mounts[_id];
    }

    function totalMounts() public view returns (uint256) {
        return mounts.length;
    }
}
