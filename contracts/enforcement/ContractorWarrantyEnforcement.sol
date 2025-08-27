// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ContractorWarrantyEnforcement {
    address public steward;
    uint256 constant warrantyPeriod = 10 * 365 days;

    struct WarrantyClaim {
        string projectName;
        address contractor;
        string defect;
        uint256 timestamp;
        bool resolved;
        string resolutionNotes;
    }

    WarrantyClaim[] public claims;

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized warranty ritual.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function fileClaim(string memory projectName, address contractor, string memory defect) public onlySteward {
        claims.push(WarrantyClaim({
            projectName: projectName,
            contractor: contractor,
            defect: defect,
            timestamp: block.timestamp,
            resolved: false,
            resolutionNotes: ""
        }));
    }

    function resolveClaim(uint256 index, string memory notes) public onlySteward {
        require(index < claims.length, "Invalid claim index.");
        require(block.timestamp <= claims[index].timestamp + warrantyPeriod, "Warranty expired.");
        claims[index].resolved = true;
        claims[index].resolutionNotes = notes;
    }

    function auditClaim(uint256 index) public view returns (string memory) {
        WarrantyClaim memory c = claims[index];
        return string(abi.encodePacked(
            "Project: ", c.projectName,
            " | Contractor: ", toAsciiString(c.contractor),
            " | Defect: ", c.defect,
            " | Timestamp: ", uint2str(c.timestamp),
            " | Resolved: ", c.resolved ? "Yes" : "No",
            " | Notes: ", c.resolutionNotes
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
