// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EquityFreedomBridge {
    struct EquityFreedom {
        address steward;
        string arc;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    EquityFreedom[] public equities;

    event EquityFreedomLogged(address indexed steward, string arc, string safeguard);
    event EquityFreedomSafeguarded(uint256 indexed id, address verifier);

    function logEquityFreedom(string memory _arc, string memory _safeguard) public {
        equities.push(EquityFreedom(msg.sender, _arc, _safeguard, block.timestamp, false));
        emit EquityFreedomLogged(msg.sender, _arc, _safeguard);
    }

    function safeguardEquityFreedom(uint256 _id) public {
        require(_id < equities.length, "Invalid ID");
        equities[_id].safeguarded = true;
        emit EquityFreedomSafeguarded(_id, msg.sender);
    }

    function getEquityFreedom(uint256 _id) public view returns (EquityFreedom memory) {
        require(_id < equities.length, "Invalid ID");
        return equities[_id];
    }

    function totalEquities() public view returns (uint256) {
        return equities.length;
    }
}
