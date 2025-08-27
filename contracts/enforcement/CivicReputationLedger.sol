// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract CivicReputationLedger {
    address public steward;

    struct ReputationProfile {
        address actor;
        string role; // e.g., Contractor, Supplier, LGU Partner
        uint256 emotionalAPR;
        uint256 trustScore;
        uint256 timestamp;
        bool auditFlag;
        bool blacklistSync;
    }

    mapping(address => ReputationProfile) public profiles;

    event ReputationUpdated(address actor, uint256 emotionalAPR, uint256 trustScore);
    event AuditTriggered(address actor);
    event BlacklistSynced(address actor);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized reputation ritual.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function updateReputation(
        address actor,
        string memory role,
        uint256 emotionalAPR,
        uint256 trustScore
    ) public onlySteward {
        bool audit = emotionalAPR < 60 || trustScore < 50;
        bool blacklist = emotionalAPR < 40 && trustScore < 30;

        profiles[actor] = ReputationProfile({
            actor: actor,
            role: role,
            emotionalAPR: emotionalAPR,
            trustScore: trustScore,
            timestamp: block.timestamp,
            auditFlag: audit,
            blacklistSync: blacklist
        });

        emit ReputationUpdated(actor, emotionalAPR, trustScore);
        if (audit) emit AuditTriggered(actor);
        if (blacklist) emit BlacklistSynced(actor);
    }

    function auditProfile(address actor) public view returns (string memory) {
        ReputationProfile memory p = profiles[actor];
        return string(abi.encodePacked(
            "Actor: ", toAsciiString(p.actor),
            " | Role: ", p.role,
            " | Emotional APR: ", uint2str(p.emotionalAPR),
            " | Trust Score: ", uint2str(p.trustScore),
            " | Audit Flag: ", p.auditFlag ? "Yes" : "No",
            " | Blacklist Sync: ", p.blacklistSync ? "Yes" : "No",
            " | Timestamp: ", uint2str(p.timestamp)
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i; uint256 len;
        while (j != 0) { len++; j /= 10; }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k--; bstr[k] = bytes1(uint8(48 + _i % 10)); _i /= 10;
        }
        return string(bstr);
    }

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(42);
        s[0] = '0'; s[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            s[2+i*2] = char(uint8(b) / 16);
            s[3+i*2] = char(uint8(b) % 16);
        }
        return string(s);
    }

    function char(uint8 b) internal pure returns (bytes1) {
        return b < 10 ? bytes1(b + 48) : bytes1(b + 87);
    }
}
