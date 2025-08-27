// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract PoliceDefenseScroll {
    address public steward;
    address public protectedOfficial;
    string public role;
    bool public familyIncluded;
    uint256 public threatLevel;
    bool public activeProtection;

    event ProtectionActivated(address official, string role, bool familyIncluded);
    event ThreatAuditTriggered(address official, uint256 threatLevel);

    constructor(address _official, string memory _role, bool _familyIncluded, uint256 _threatLevel) {
        steward = msg.sender;
        protectedOfficial = _official;
        role = _role;
        familyIncluded = _familyIncluded;
        threatLevel = _threatLevel;
        activeProtection = false;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scroll activation.");
        _;
    }

    function activateProtection() public onlySteward {
        require(threatLevel >= 75, "Threat level not high enough.");
        activeProtection = true;
        emit ProtectionActivated(protectedOfficial, role, familyIncluded);
        emit ThreatAuditTriggered(protectedOfficial, threatLevel);
    }

    function auditStatus() public view returns (string memory) {
        return string(abi.encodePacked(
            "Official: ", toAsciiString(protectedOfficial),
            " | Role: ", role,
            " | Threat Level: ", uint2str(threatLevel),
            " | Family Included: ", familyIncluded ? "Yes" : "No",
            " | Protection Active: ", activeProtection ? "Yes" : "No"
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
