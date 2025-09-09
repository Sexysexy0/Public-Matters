// SPDX-License-Identifier: CasualtyAudit-License
pragma solidity ^0.8.0;

contract MilitaryCasualtyAuditProtocol {
    address public steward;

    struct CasualtyClaim {
        string country;
        uint256 claimedLosses;
        uint256 verifiedLosses;
        string source;
        string auditStatus;
        uint256 timestamp;
    }

    CasualtyClaim[] public claims;

    event CasualtyClaimLogged(string country, uint256 claimed, uint256 verified, string source, string status, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logClaim(string memory country, uint256 claimedLosses, uint256 verifiedLosses, string memory source) public {
        require(msg.sender == steward, "Only steward can log");
        string memory status = (verifiedLosses > 0) ? "Verified" : "Unverified";
        claims.push(CasualtyClaim(country, claimedLosses, verifiedLosses, source, status, block.timestamp));
        emit CasualtyClaimLogged(country, claimedLosses, verifiedLosses, source, status, block.timestamp);
    }

    function getClaim(uint index) public view returns (string memory, uint256, uint256, string memory, string memory, uint256) {
        CasualtyClaim memory c = claims[index];
        return (c.country, c.claimedLosses, c.verifiedLosses, c.source, c.auditStatus, c.timestamp);
    }
}
