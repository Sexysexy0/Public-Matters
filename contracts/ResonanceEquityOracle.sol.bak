// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResonanceEquityOracle {
    struct ResonanceEquity {
        address overseer;
        string arc;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    ResonanceEquity[] public resonances;

    event ResonanceEquityLogged(address indexed overseer, string arc, string safeguard);
    event ResonanceEquitySafeguarded(uint256 indexed id, address verifier);

    function logResonanceEquity(string memory _arc, string memory _safeguard) public {
        resonances.push(ResonanceEquity(msg.sender, _arc, _safeguard, block.timestamp, false));
        emit ResonanceEquityLogged(msg.sender, _arc, _safeguard);
    }

    function safeguardResonanceEquity(uint256 _id) public {
        require(_id < resonances.length, "Invalid ID");
        resonances[_id].safeguarded = true;
        emit ResonanceEquitySafeguarded(_id, msg.sender);
    }

    function getResonanceEquity(uint256 _id) public view returns (ResonanceEquity memory) {
        require(_id < resonances.length, "Invalid ID");
        return resonances[_id];
    }

    function totalResonances() public view returns (uint256) {
        return resonances.length;
    }
}
