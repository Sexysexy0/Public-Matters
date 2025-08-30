// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KinderSanctumReliefPack {
    struct ReliefClaim {
        string stewardName;
        string barangay;
        uint256 incomeLevel;
        uint8 emotionalAPR; // Scale: 0–100
        bool tariffAffected;
        string reliefType; // e.g., "Food Subsidy", "Housing Credit", "Emotional APR Sync"
        uint256 timestamp;
        string notes;
    }

    ReliefClaim[] public claims;

    event ReliefLogged(string stewardName, string reliefType, uint8 emotionalAPR);

    function logClaim(
        string memory stewardName,
        string memory barangay,
        uint256 incomeLevel,
        uint8 emotionalAPR,
        bool tariffAffected,
        string memory reliefType,
        string memory notes
    ) public {
        require(emotionalAPR <= 100, "Invalid APR score");
        claims.push(ReliefClaim({
            stewardName: stewardName,
            barangay: barangay,
            incomeLevel: incomeLevel,
            emotionalAPR: emotionalAPR,
            tariffAffected: tariffAffected,
            reliefType: reliefType,
            timestamp: block.timestamp,
            notes: notes
        }));

        emit ReliefLogged(stewardName, reliefType, emotionalAPR);
    }

    function getClaim(uint256 index) public view returns (ReliefClaim memory) {
        require(index < claims.length, "Invalid index");
        return claims[index];
    }

    function getTotalClaims() public view returns (uint256) {
        return claims.length;
    }
}
