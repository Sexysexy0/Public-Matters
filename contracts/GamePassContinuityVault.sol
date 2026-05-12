// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GamePassContinuityVault {
    struct EssentialDrop {
        address subscriber;
        string title;
        uint256 timestamp;
        bool safeguarded;
    }

    EssentialDrop[] public drops;

    event DropLogged(address indexed subscriber, string title);
    event DropSafeguarded(uint256 indexed id, address verifier);

    function logDrop(string memory _title) public {
        drops.push(EssentialDrop(msg.sender, _title, block.timestamp, false));
        emit DropLogged(msg.sender, _title);
    }

    function safeguardDrop(uint256 _id) public {
        require(_id < drops.length, "Invalid ID");
        drops[_id].safeguarded = true;
        emit DropSafeguarded(_id, msg.sender);
    }

    function getDrop(uint256 _id) public view returns (EssentialDrop memory) {
        require(_id < drops.length, "Invalid ID");
        return drops[_id];
    }

    function totalDrops() public view returns (uint256) {
        return drops.length;
    }
}
