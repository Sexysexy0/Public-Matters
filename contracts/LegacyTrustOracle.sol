// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LegacyTrustOracle {
    struct Trust {
        address steward;
        string legacy;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Trust[] public trusts;

    event TrustLogged(address indexed steward, string legacy, string safeguard);
    event TrustSafeguarded(uint256 indexed id, address verifier);

    function logTrust(string memory _legacy, string memory _safeguard) public {
        trusts.push(Trust(msg.sender, _legacy, _safeguard, block.timestamp, false));
        emit TrustLogged(msg.sender, _legacy, _safeguard);
    }

    function safeguardTrust(uint256 _id) public {
        require(_id < trusts.length, "Invalid ID");
        trusts[_id].safeguarded = true;
        emit TrustSafeguarded(_id, msg.sender);
    }

    function getTrust(uint256 _id) public view returns (Trust memory) {
        require(_id < trusts.length, "Invalid ID");
        return trusts[_id];
    }

    function totalTrusts() public view returns (uint256) {
        return trusts.length;
    }
}
