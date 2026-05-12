// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CollectorTransparencyVault {
    struct Transparency {
        address collector;
        string label;
        uint256 timestamp;
        bool safeguarded;
    }

    Transparency[] public transparencies;

    event TransparencyLogged(address indexed collector, string label);
    event TransparencySafeguarded(uint256 indexed id, address verifier);

    function logTransparency(string memory _label) public {
        transparencies.push(Transparency(msg.sender, _label, block.timestamp, false));
        emit TransparencyLogged(msg.sender, _label);
    }

    function safeguardTransparency(uint256 _id) public {
        require(_id < transparencies.length, "Invalid ID");
        transparencies[_id].safeguarded = true;
        emit TransparencySafeguarded(_id, msg.sender);
    }

    function getTransparency(uint256 _id) public view returns (Transparency memory) {
        require(_id < transparencies.length, "Invalid ID");
        return transparencies[_id];
    }

    function totalTransparencies() public view returns (uint256) {
        return transparencies.length;
    }
}
