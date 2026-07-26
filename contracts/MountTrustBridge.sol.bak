// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MountTrustBridge {
    struct MountTrust {
        address rider;
        string mountType;
        uint256 trustLevel;
        uint256 timestamp;
        bool safeguarded;
    }

    MountTrust[] public trusts;

    event TrustLogged(address indexed rider, string mountType, uint256 trustLevel);
    event TrustSafeguarded(uint256 indexed id, address verifier);

    function logTrust(string memory _mountType, uint256 _trustLevel) public {
        trusts.push(MountTrust(msg.sender, _mountType, _trustLevel, block.timestamp, false));
        emit TrustLogged(msg.sender, _mountType, _trustLevel);
    }

    function safeguardTrust(uint256 _id) public {
        require(_id < trusts.length, "Invalid ID");
        trusts[_id].safeguarded = true;
        emit TrustSafeguarded(_id, msg.sender);
    }

    function getTrust(uint256 _id) public view returns (MountTrust memory) {
        require(_id < trusts.length, "Invalid ID");
        return trusts[_id];
    }

    function totalTrusts() public view returns (uint256) {
        return trusts.length;
    }
}
