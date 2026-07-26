// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecurityGuardianVault {
    struct Breach {
        address reporter;
        string incident;
        uint256 timestamp;
        bool patched;
    }

    Breach[] public breaches;

    event BreachLogged(address indexed reporter, string incident);
    event BreachPatched(uint256 indexed id, address verifier);

    function logBreach(string memory _incident) public {
        breaches.push(Breach(msg.sender, _incident, block.timestamp, false));
        emit BreachLogged(msg.sender, _incident);
    }

    function patchBreach(uint256 _id) public {
        require(_id < breaches.length, "Invalid ID");
        breaches[_id].patched = true;
        emit BreachPatched(_id, msg.sender);
    }

    function getBreach(uint256 _id) public view returns (Breach memory) {
        require(_id < breaches.length, "Invalid ID");
        return breaches[_id];
    }

    function totalBreaches() public view returns (uint256) {
        return breaches.length;
    }
}
