// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StateEquityShield {
    struct StateEquity {
        address overseer;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    StateEquity[] public equities;

    event StateEquityLogged(address indexed overseer, string context, string safeguard);
    event StateEquitySafeguarded(uint256 indexed id, address verifier);

    function logStateEquity(string memory _context, string memory _safeguard) public {
        equities.push(StateEquity(msg.sender, _context, _safeguard, block.timestamp, false));
        emit StateEquityLogged(msg.sender, _context, _safeguard);
    }

    function safeguardStateEquity(uint256 _id) public {
        require(_id < equities.length, "Invalid ID");
        equities[_id].safeguarded = true;
        emit StateEquitySafeguarded(_id, msg.sender);
    }

    function getStateEquity(uint256 _id) public view returns (StateEquity memory) {
        require(_id < equities.length, "Invalid ID");
        return equities[_id];
    }

    function totalEquities() public view returns (uint256) {
        return equities.length;
    }
}
