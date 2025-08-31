// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

interface IAPROracle {
    function getAPR(string memory _name) external view returns (uint);
}

interface ISanctumWhitelist {
    function isApproved(string memory _sanctum) external view returns (bool);
}

interface IPlanetaryOverrideSuite {
    function isOverrideTriggered(string memory _actor) external view returns (bool);
}

interface ISanctumRecoveryProtocol {
    function isReformComplete(string memory _actor) external view returns (bool);
}

contract BitMarketGatekeeper {
    address public aprOracle;
    address public whitelist;
    address public overrideSuite;
    address public recoveryProtocol;

    constructor(
        address _aprOracle,
        address _whitelist,
        address _overrideSuite,
        address _recoveryProtocol
    ) {
        aprOracle = _aprOracle;
        whitelist = _whitelist;
        overrideSuite = _overrideSuite;
        recoveryProtocol = _recoveryProtocol;
    }

    event AccessGranted(string actor);
    event AccessDenied(string actor, string reason);

    function validateAccess(string memory _actor, string memory _sanctum) public returns (bool) {
        uint apr = IAPROracle(aprOracle).getAPR(_actor);
        bool isWhitelisted = ISanctumWhitelist(whitelist).isApproved(_sanctum);
        bool isOverridden = IPlanetaryOverrideSuite(overrideSuite).isOverrideTriggered(_actor);
        bool isReformed = ISanctumRecoveryProtocol(recoveryProtocol).isReformComplete(_actor);

        if (isOverridden && !isReformed) {
            emit AccessDenied(_actor, "Override active, no reform");
            return false;
        }
        if (apr < 60) {
            emit AccessDenied(_actor, "Low emotional APR");
            return false;
        }
        if (!isWhitelisted) {
            emit AccessDenied(_actor, "Sanctum not whitelisted");
            return false;
        }

        emit AccessGranted(_actor);
        return true;
    }
}
