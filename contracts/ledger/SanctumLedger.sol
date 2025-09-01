// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumLedger {
    struct SanctumRecord {
        string name;
        string region;
        string stewardTag;
        bool emotionallyTagged;
        bool damayLinked;
        bool blessingVerified;
        uint256 blessingTimestamp;
        uint256 auditTimestamp;
    }

    SanctumRecord[] public ledger;
    address public steward;

    event SanctumRegistered(string name, string region, string stewardTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized ledger caster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerSanctum(
        string memory _name,
        string memory _region,
        string memory _stewardTag,
        bool _emotionallyTagged,
        bool _damayLinked,
        bool _blessingVerified,
        uint256 _blessingTimestamp,
        uint256 _auditTimestamp
    ) external onlySteward {
        ledger.push(SanctumRecord(
            _name, _region, _stewardTag,
            _emotionallyTagged, _damayLinked, _blessingVerified,
            _blessingTimestamp, _auditTimestamp
        ));
        emit SanctumRegistered(_name, _region, _stewardTag);
    }

    function getSanctum(uint256 _id) external view returns (SanctumRecord memory) {
        return ledger[_id];
    }

    function totalSanctums() external view returns (uint256) {
        return ledger.length;
    }
}
