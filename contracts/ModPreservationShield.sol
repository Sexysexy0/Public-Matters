// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ModPreservationShield {
    struct Mod {
        address player;
        string modName;
        uint256 timestamp;
        bool preserved;
    }

    Mod[] public mods;

    event ModLogged(address indexed player, string modName);
    event ModPreserved(uint256 indexed id, address verifier);

    function logMod(string memory _modName) public {
        mods.push(Mod(msg.sender, _modName, block.timestamp, false));
        emit ModLogged(msg.sender, _modName);
    }

    function preserveMod(uint256 _id) public {
        require(_id < mods.length, "Invalid ID");
        mods[_id].preserved = true;
        emit ModPreserved(_id, msg.sender);
    }

    function getMod(uint256 _id) public view returns (Mod memory) {
        require(_id < mods.length, "Invalid ID");
        return mods[_id];
    }

    function totalMods() public view returns (uint256) {
        return mods.length;
    }
}
