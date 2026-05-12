// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HouseDecorVault {
    struct Decor {
        address owner;
        string item;
        uint256 timestamp;
        bool safeguarded;
    }

    Decor[] public decors;

    event DecorLogged(address indexed owner, string item);
    event DecorSafeguarded(uint256 indexed id, address verifier);

    function logDecor(string memory _item) public {
        decors.push(Decor(msg.sender, _item, block.timestamp, false));
        emit DecorLogged(msg.sender, _item);
    }

    function safeguardDecor(uint256 _id) public {
        require(_id < decors.length, "Invalid ID");
        decors[_id].safeguarded = true;
        emit DecorSafeguarded(_id, msg.sender);
    }

    function getDecor(uint256 _id) public view returns (Decor memory) {
        require(_id < decors.length, "Invalid ID");
        return decors[_id];
    }

    function totalDecors() public view returns (uint256) {
        return decors.length;
    }
}
