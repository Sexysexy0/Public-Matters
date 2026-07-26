// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MountTrustLedger {
    struct Mount {
        address tamer;
        string species;
        uint256 timestamp;
        bool trusted;
        string perk;
    }

    Mount[] public mounts;

    event MountTamed(address indexed tamer, string species, string perk);
    event TrustBuilt(uint256 indexed id, address verifier);

    function tameMount(string memory _species, string memory _perk) public {
        mounts.push(Mount(msg.sender, _species, block.timestamp, false, _perk));
        emit MountTamed(msg.sender, _species, _perk);
    }

    function buildTrust(uint256 _id) public {
        require(_id < mounts.length, "Invalid ID");
        mounts[_id].trusted = true;
        emit TrustBuilt(_id, msg.sender);
    }

    function getMount(uint256 _id) public view returns (Mount memory) {
        require(_id < mounts.length, "Invalid ID");
        return mounts[_id];
    }

    function totalMounts() public view returns (uint256) {
        return mounts.length;
    }
}
