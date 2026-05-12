// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityEquityShield {
    struct Equity {
        address steward;
        string community;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Equity[] public equities;

    event EquityLogged(address indexed steward, string community, string safeguard);
    event EquitySafeguarded(uint256 indexed id, address verifier);

    function logEquity(string memory _community, string memory _safeguard) public {
        equities.push(Equity(msg.sender, _community, _safeguard, block.timestamp, false));
        emit EquityLogged(msg.sender, _community, _safeguard);
    }

    function safeguardEquity(uint256 _id) public {
        require(_id < equities.length, "Invalid ID");
        equities[_id].safeguarded = true;
        emit EquitySafeguarded(_id, msg.sender);
    }

    function getEquity(uint256 _id) public view returns (Equity memory) {
        require(_id < equities.length, "Invalid ID");
        return equities[_id];
    }

    function totalEquities() public view returns (uint256) {
        return equities.length;
    }
}
