// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract AnchorGovernanceVault {
    address public cyberRegistry;
    address public securitySentry;

    constructor(address _cyber, address _sentry) {
        require(_cyber != address(0), "Cyber registry input zero verification fail");
        require(_sentry != address(0), "Security sentry input zero verification fail");
        cyberRegistry = _cyber;
        securitySentry = _sentry;
    }
}
