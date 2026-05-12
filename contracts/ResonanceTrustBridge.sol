// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResonanceTrustBridge {
    struct TrustRecord {
        address member;
        string context;
        string resonance;
        uint256 timestamp;
        bool safeguarded;
    }

    TrustRecord[] public records;

    event TrustLogged(address indexed member, string context, string resonance);
    event TrustSafeguarded(uint256 indexed id, address verifier);

    function logTrust(string memory _context, string memory _resonance) public {
        records.push(TrustRecord(msg.sender, _context, _resonance, block.timestamp, false));
        emit TrustLogged(msg.sender, _context, _resonance);
    }

    function safeguardTrust(uint256 _id) public {
        require(_id < records.length, "Invalid ID");
        records[_id].safeguarded = true;
        emit TrustSafeguarded(_id, msg.sender);
    }

    function getTrust(uint256 _id) public view returns (TrustRecord memory) {
        require(_id < records.length, "Invalid ID");
        return records[_id];
    }

    function totalTrusts() public view returns (uint256) {
        return records.length;
    }
}
