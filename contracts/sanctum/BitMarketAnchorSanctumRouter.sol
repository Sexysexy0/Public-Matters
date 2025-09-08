// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "./BitMarketTrustAnchorSanctifier.sol";

contract BitMarketAnchorSanctumRouter {
    BitMarketTrustAnchorSanctifier public sanctifier;
    address public steward;

    event AnchorRouted(string email, bool isValid, string routeStatus);

    constructor(address sanctifierAddress) {
        sanctifier = BitMarketTrustAnchorSanctifier(sanctifierAddress);
        steward = msg.sender;
    }

    function routeEmail(string memory email) public {
        bool isValid = sanctifier.validateEmailAnchor(email);
        string memory routeStatus = isValid ? "Routed to reset flow" : "Blocked by spoof firewall";
        emit AnchorRouted(email, isValid, routeStatus);
    }
}
