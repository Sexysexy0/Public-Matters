// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ManufacturingContinuityBridge {
    struct ManufacturingContinuity {
        address steward;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    ManufacturingContinuity[] public continuities;

    event ManufacturingContinuityLogged(address indexed steward, string context, string safeguard);
    event ManufacturingContinuitySafeguarded(uint256 indexed id, address verifier);

    function logManufacturingContinuity(string memory _context, string memory _safeguard) public {
        continuities.push(ManufacturingContinuity(msg.sender, _context, _safeguard, block.timestamp, false));
        emit ManufacturingContinuityLogged(msg.sender, _context, _safeguard);
    }

    function safeguardManufacturingContinuity(uint256 _id) public {
        require(_id < continuities.length, "Invalid ID");
        continuities[_id].safeguarded = true;
        emit ManufacturingContinuitySafeguarded(_id, msg.sender);
    }

    function getManufacturingContinuity(uint256 _id) public view returns (ManufacturingContinuity memory) {
        require(_id < continuities.length, "Invalid ID");
        return continuities[_id];
    }

    function totalContinuities() public view returns (uint256) {
        return continuities.length;
    }
}
