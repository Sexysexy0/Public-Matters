// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ContractorBlacklistDeck {
    address public steward;

    struct BlacklistedContractor {
        address contractor;
        string projectName;
        string violation;
        uint256 emotionalAPR;
        uint256 timestamp;
        uint256 fineAmount;
        bool jailTrigger;
        bool isBlacklisted;
    }

    BlacklistedContractor[] public blacklist;

    event ContractorBlacklisted(address contractor, string projectName, string violation);
    event PenaltyEnforced(address contractor, uint256 fineAmount, bool jailTrigger);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized blacklist ritual.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blacklistContractor(
        address contractor,
        string memory projectName,
        string memory violation,
        uint256 emotionalAPR,
        uint256 fineAmount,
        bool jailTrigger
    ) public onlySteward {
        require(emotionalAPR < 50, "Violation not severe enough for blacklist.");

        blacklist.push(BlacklistedContractor({
            contractor: contractor,
            projectName: projectName,
            violation: violation,
            emotionalAPR: emotionalAPR,
            timestamp: block.timestamp,
            fineAmount: fineAmount,
            jailTrigger: jailTrigger,
            isBlacklisted: true
        }));

        emit ContractorBlacklisted(contractor, projectName, violation);
        emit PenaltyEnforced(contractor, fineAmount, jailTrigger);
    }

    function auditBlacklist(uint256 index) public view returns (string memory) {
        BlacklistedContractor memory b = blacklist[index];
        return string(abi.encodePacked(
            "Contractor: ", toAsciiString(b.contractor),
            " | Project: ", b.projectName,
            " | Violation: ", b.violation,
            " | Emotional APR: ", uint2str(b.emotionalAPR),
            " | Fine: ₱", uint2str(b.fineAmount),
            " | Jail Trigger: ", b.jailTrigger ? "Yes" : "No",
            " | Timestamp: ", uint2str(b.timestamp)
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
