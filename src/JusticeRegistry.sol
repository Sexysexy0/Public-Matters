// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract JusticeRegistry {
    struct AccountabilityRecord {
        string institutionOrLeader;
        string commitment;
        uint256 filingTimestamp;
        bool fulfilled;
        bool challenged;
        address challenger;
    }

    mapping(bytes32 => AccountabilityRecord) public records;
    address public immutable supremeAuditor;

    event CommitmentLogged(bytes32 indexed recordId, string entity, string commitment);
    event AccountabilityChallenged(bytes32 indexed recordId, address challenger);
    event FulfillmentVerified(bytes32 indexed recordId, bool fulfilled);

    modifier onlyAuditor() {
        require(msg.sender == supremeAuditor, "Unauthorized: Supreme Auditor only");
        _;
    }

    constructor() {
        supremeAuditor = msg.sender;
    }

    function logCommitment(bytes32 _recordId, string memory _institutionOrLeader, string memory _commitment)
        external
        onlyAuditor
    {
        require(records[_recordId].filingTimestamp == 0, "Record already exists");

        records[_recordId] = AccountabilityRecord({
            institutionOrLeader: _institutionOrLeader,
            commitment: _commitment,
            filingTimestamp: block.timestamp,
            fulfilled: false,
            challenged: false,
            challenger: address(0)
        });

        emit CommitmentLogged(_recordId, _institutionOrLeader, _commitment);
    }

    function challengeAccountability(bytes32 _recordId) external {
        AccountabilityRecord storage rec = records[_recordId];
        require(rec.filingTimestamp > 0, "Record does not exist");
        require(!rec.fulfilled, "Already marked as fulfilled");

        rec.challenged = true;
        rec.challenger = msg.sender;

        emit AccountabilityChallenged(_recordId, msg.sender);
    }

    function verifyFulfillment(bytes32 _recordId, bool _status) external onlyAuditor {
        AccountabilityRecord storage rec = records[_recordId];
        require(rec.filingTimestamp > 0, "Record does not exist");

        rec.fulfilled = _status;
        emit FulfillmentVerified(_recordId, _status);
    }

    function getRecord(bytes32 _recordId)
        external
        view
        returns (string memory, string memory, uint256, bool, bool, address)
    {
        AccountabilityRecord memory r = records[_recordId];
        return (r.institutionOrLeader, r.commitment, r.filingTimestamp, r.fulfilled, r.challenged, r.challenger);
    }
}
