// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StrategicHiatusVault {
    struct Hiatus {
        address actor;
        string reason;
        uint256 duration;
        uint256 timestamp;
        bool safeguarded;
    }

    Hiatus[] public hiatuses;

    event HiatusLogged(address indexed actor, string reason, uint256 duration);
    event HiatusSafeguarded(uint256 indexed id, address verifier);

    function logHiatus(string memory _reason, uint256 _duration) public {
        hiatuses.push(Hiatus(msg.sender, _reason, _duration, block.timestamp, false));
        emit HiatusLogged(msg.sender, _reason, _duration);
    }

    function safeguardHiatus(uint256 _id) public {
        require(_id < hiatuses.length, "Invalid ID");
        hiatuses[_id].safeguarded = true;
        emit HiatusSafeguarded(_id, msg.sender);
    }

    function getHiatus(uint256 _id) public view returns (Hiatus memory) {
        require(_id < hiatuses.length, "Invalid ID");
        return hiatuses[_id];
    }

    function totalHiatuses() public view returns (uint256) {
        return hiatuses.length;
    }
}
