// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SupplyConstraintShield {
    struct SupplyConstraint {
        address overseer;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    SupplyConstraint[] public constraints;

    event SupplyConstraintLogged(address indexed overseer, string context, string safeguard);
    event SupplyConstraintSafeguarded(uint256 indexed id, address verifier);

    function logSupplyConstraint(string memory _context, string memory _safeguard) public {
        constraints.push(SupplyConstraint(msg.sender, _context, _safeguard, block.timestamp, false));
        emit SupplyConstraintLogged(msg.sender, _context, _safeguard);
    }

    function safeguardSupplyConstraint(uint256 _id) public {
        require(_id < constraints.length, "Invalid ID");
        constraints[_id].safeguarded = true;
        emit SupplyConstraintSafeguarded(_id, msg.sender);
    }

    function getSupplyConstraint(uint256 _id) public view returns (SupplyConstraint memory) {
        require(_id < constraints.length, "Invalid ID");
        return constraints[_id];
    }

    function totalConstraints() public view returns (uint256) {
        return constraints.length;
    }
}
