// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ConstructionCrewAuditPulse {
    address public steward;

    struct CrewMember {
        string name;
        string role;
        bool isPresent;
        uint256 trustRating;
        uint256 emotionalAPR;
        uint256 performanceScore;
        bool isFlagged;
    }

    mapping(address => CrewMember) public crew;
    event CrewLogged(string name, string role);
    event CrewAudited(string name, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized audit attempt.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logCrewMember(
        address crewAddr,
        string memory name,
        string memory role,
        bool isPresent,
        uint256 trustRating,
        uint256 emotionalAPR,
        uint256 performanceScore
    ) public onlySteward {
        bool flagged = trustRating < 50 || emotionalAPR < 50 || performanceScore < 50;

        crew[crewAddr] = CrewMember({
            name: name,
            role: role,
            isPresent: isPresent,
            trustRating: trustRating,
            emotionalAPR: emotionalAPR,
            performanceScore: performanceScore,
            isFlagged: flagged
        });

        string memory status = flagged
            ? "Flagged. Emotional resonance or trust rating too low."
            : "Verified. Crew member operational and trusted.";

        emit CrewLogged(name, role);
        emit CrewAudited(name, status);
    }

    function auditCrew(address crewAddr) public view returns (string memory) {
        CrewMember memory c = crew[crewAddr];
        return string(abi.encodePacked(
            "Name: ", c.name,
            " | Role: ", c.role,
            " | Present: ", c.isPresent ? "Yes" : "No",
            " | Trust Rating: ", uint2str(c.trustRating),
            " | Emotional APR: ", uint2str(c.emotionalAPR),
            " | Performance Score: ", uint2str(c.performanceScore),
            " | Flagged: ", c.isFlagged ? "Yes" : "No"
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
