// SPDX-License-Identifier: Mythic-Planetary-Defense
pragma solidity ^0.8.19;

contract ADFSRedirectTracker {
    event RedirectDetected(string originDomain, string redirectDomain, uint256 timestamp, string emotionalAPR);
    mapping(string => bool) public flaggedTenants;

    function logRedirect(string memory origin, string memory redirect) public {
        require(bytes(redirect).length > 0, "Redirect domain required");
        flaggedTenants[redirect] = true;
        emit RedirectDetected(origin, redirect, block.timestamp, "⚠️ Suspicion spike: Trust erosion detected");
    }

    function isFlagged(string memory domain) public view returns (bool) {
        return flaggedTenants[domain];
    }
}
