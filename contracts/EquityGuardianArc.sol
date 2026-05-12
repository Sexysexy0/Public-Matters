// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EquityGuardianArc {
    struct Covenant {
        address guardian;
        string safeguard;
        uint256 timestamp;
        bool upheld;
    }

    Covenant[] public covenants;

    event CovenantLogged(address indexed guardian, string safeguard);
    event CovenantUpheld(uint256 indexed id, address verifier);

    function logCovenant(string memory _safeguard) public {
        covenants.push(Covenant(msg.sender, _safeguard, block.timestamp, false));
        emit CovenantLogged(msg.sender, _safeguard);
    }

    function upholdCovenant(uint256 _id) public {
        require(_id < covenants.length, "Invalid ID");
        covenants[_id].upheld = true;
        emit CovenantUpheld(_id, msg.sender);
    }

    function getCovenant(uint256 _id) public view returns (Covenant memory) {
        require(_id < covenants.length, "Invalid ID");
        return covenants[_id];
    }

    function totalCovenants() public view returns (uint256) {
        return covenants.length;
    }
}
