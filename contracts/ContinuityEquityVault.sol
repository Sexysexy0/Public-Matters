// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ContinuityEquityVault {
    struct ContinuityRecord {
        address subscriber;
        string tier;
        string safeguard;
        uint256 timestamp;
        bool anchored;
    }

    ContinuityRecord[] public records;

    event ContinuityLogged(address indexed subscriber, string tier, string safeguard);
    event ContinuityAnchored(uint256 indexed id, address verifier);

    function logContinuity(string memory _tier, string memory _safeguard) public {
        records.push(ContinuityRecord(msg.sender, _tier, _safeguard, block.timestamp, false));
        emit ContinuityLogged(msg.sender, _tier, _safeguard);
    }

    function anchorContinuity(uint256 _id) public {
        require(_id < records.length, "Invalid ID");
        records[_id].anchored = true;
        emit ContinuityAnchored(_id, msg.sender);
    }

    function getContinuity(uint256 _id) public view returns (ContinuityRecord memory) {
        require(_id < records.length, "Invalid ID");
        return records[_id];
    }

    function totalContinuities() public view returns (uint256) {
        return records.length;
    }
}
