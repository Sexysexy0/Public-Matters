// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HeritageResonanceBridge {
    struct Heritage {
        address curator;
        string culture;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Heritage[] public heritages;

    event HeritageLogged(address indexed curator, string culture, string safeguard);
    event HeritageSafeguarded(uint256 indexed id, address verifier);

    function logHeritage(string memory _culture, string memory _safeguard) public {
        heritages.push(Heritage(msg.sender, _culture, _safeguard, block.timestamp, false));
        emit HeritageLogged(msg.sender, _culture, _safeguard);
    }

    function safeguardHeritage(uint256 _id) public {
        require(_id < heritages.length, "Invalid ID");
        heritages[_id].safeguarded = true;
        emit HeritageSafeguarded(_id, msg.sender);
    }

    function getHeritage(uint256 _id) public view returns (Heritage memory) {
        require(_id < heritages.length, "Invalid ID");
        return heritages[_id];
    }

    function totalHeritages() public view returns (uint256) {
        return heritages.length;
    }
}
