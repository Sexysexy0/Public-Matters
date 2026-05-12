// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CritiqueResonanceShield {
    struct Critique {
        address overseer;
        string arc;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Critique[] public critiques;

    event CritiqueLogged(address indexed overseer, string arc, string safeguard);
    event CritiqueSafeguarded(uint256 indexed id, address verifier);

    function logCritique(string memory _arc, string memory _safeguard) public {
        critiques.push(Critique(msg.sender, _arc, _safeguard, block.timestamp, false));
        emit CritiqueLogged(msg.sender, _arc, _safeguard);
    }

    function safeguardCritique(uint256 _id) public {
        require(_id < critiques.length, "Invalid ID");
        critiques[_id].safeguarded = true;
        emit CritiqueSafeguarded(_id, msg.sender);
    }

    function getCritique(uint256 _id) public view returns (Critique memory) {
        require(_id < critiques.length, "Invalid ID");
        return critiques[_id];
    }

    function totalCritiques() public view returns (uint256) {
        return critiques.length;
    }
}
