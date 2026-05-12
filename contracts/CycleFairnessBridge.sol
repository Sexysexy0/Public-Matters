// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CycleFairnessBridge {
    struct Reset {
        address overseer;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Reset[] public resets;

    event ResetLogged(address indexed overseer, string context, string safeguard);
    event ResetSafeguarded(uint256 indexed id, address verifier);

    function logReset(string memory _context, string memory _safeguard) public {
        resets.push(Reset(msg.sender, _context, _safeguard, block.timestamp, false));
        emit ResetLogged(msg.sender, _context, _safeguard);
    }

    function safeguardReset(uint256 _id) public {
        require(_id < resets.length, "Invalid ID");
        resets[_id].safeguarded = true;
        emit ResetSafeguarded(_id, msg.sender);
    }

    function getReset(uint256 _id) public view returns (Reset memory) {
        require(_id < resets.length, "Invalid ID");
        return resets[_id];
    }

    function totalResets() public view returns (uint256) {
        return resets.length;
    }
}
