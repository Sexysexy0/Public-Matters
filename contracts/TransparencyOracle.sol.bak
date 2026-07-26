// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransparencyOracle {
    struct Record {
        address contributor;
        string provenance;
        uint256 timestamp;
        bool verified;
    }

    Record[] public records;

    event RecordLogged(address indexed contributor, string provenance);
    event RecordVerified(uint256 indexed id, address verifier);

    function logRecord(string memory _prov) public {
        records.push(Record(msg.sender, _prov, block.timestamp, false));
        emit RecordLogged(msg.sender, _prov);
    }

    function verifyRecord(uint256 _id) public {
        require(_id < records.length, "Invalid ID");
        records[_id].verified = true;
        emit RecordVerified(_id, msg.sender);
    }

    function getRecord(uint256 _id) public view returns (Record memory) {
        require(_id < records.length, "Invalid ID");
        return records[_id];
    }

    function totalRecords() public view returns (uint256) {
        return records.length;
    }
}
