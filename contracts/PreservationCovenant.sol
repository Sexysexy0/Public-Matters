// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PreservationCovenant {
    struct Ownership {
        address consumer;
        string asset;
        uint256 timestamp;
        bool preserved;
    }

    Ownership[] public ownerships;

    event OwnershipLogged(address indexed consumer, string asset);
    event OwnershipPreserved(uint256 indexed id, address verifier);

    function logOwnership(string memory _asset) public {
        ownerships.push(Ownership(msg.sender, _asset, block.timestamp, false));
        emit OwnershipLogged(msg.sender, _asset);
    }

    function preserveOwnership(uint256 _id) public {
        require(_id < ownerships.length, "Invalid ID");
        ownerships[_id].preserved = true;
        emit OwnershipPreserved(_id, msg.sender);
    }

    function getOwnership(uint256 _id) public view returns (Ownership memory) {
        require(_id < ownerships.length, "Invalid ID");
        return ownerships[_id];
    }

    function totalOwnerships() public view returns (uint256) {
        return ownerships.length;
    }
}
