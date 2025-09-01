// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EvictionOverrideSuite {
    struct ShelterClaim {
        address steward;
        string location;
        uint256 emotionalAPR;
        bool evictionNotice;
        bool overrideActivated;
        string overrideReason;
    }

    ShelterClaim[] public claims;

    event EvictionNoticeFiled(address steward, string location);
    event OverrideActivated(address steward, string location, string reason);

    function fileEvictionNotice(address _steward, string memory _location, uint256 _emotionalAPR) public {
        claims.push(ShelterClaim(_steward, _location, _emotionalAPR, true, false, ""));
        emit EvictionNoticeFiled(_steward, _location);
    }

    function activateOverride(uint256 _index, string memory _reason) public {
        require(_index < claims.length, "Invalid index");
        ShelterClaim storage claim = claims[_index];
        require(msg.sender == claim.steward, "Not authorized");
        require(claim.evictionNotice == true, "No eviction notice");

        claim.overrideActivated = true;
        claim.overrideReason = _reason;

        emit OverrideActivated(claim.steward, claim.location, _reason);
    }

    function getAllClaims() public view returns (ShelterClaim[] memory) {
        return claims;
    }
}
