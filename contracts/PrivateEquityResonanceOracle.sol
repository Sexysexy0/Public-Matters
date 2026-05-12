// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PrivateEquityResonanceOracle {
    struct EquityResonance {
        address overseer;
        string entity;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    EquityResonance[] public equities;

    event EquityResonanceLogged(address indexed overseer, string entity, string safeguard);
    event EquityResonanceSafeguarded(uint256 indexed id, address verifier);

    function logEquityResonance(string memory _entity, string memory _safeguard) public {
        equities.push(EquityResonance(msg.sender, _entity, _safeguard, block.timestamp, false));
        emit EquityResonanceLogged(msg.sender, _entity, _safeguard);
    }

    function safeguardEquityResonance(uint256 _id) public {
        require(_id < equities.length, "Invalid ID");
        equities[_id].safeguarded = true;
        emit EquityResonanceSafeguarded(_id, msg.sender);
    }

    function getEquityResonance(uint256 _id) public view returns (EquityResonance memory) {
        require(_id < equities.length, "Invalid ID");
        return equities[_id];
    }

    function totalEquities() public view returns (uint256) {
        return equities.length;
    }
}
