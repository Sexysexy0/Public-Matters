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

contract BitMarketValidator {
    address public aprOracle;
    address public whitelist;
    address public overrideSuite;

    constructor(address _aprOracle, address _whitelist, address _overrideSuite) {
        aprOracle = _aprOracle;
        whitelist = _whitelist;
        overrideSuite = _overrideSuite;
    }

    event ValidationPassed(string actor);
    event ValidationFailed(string actor, string reason);

    function validateVendor(string memory _actor, string memory _sanctum) public returns (bool) {
        uint apr = IAPROracle(aprOracle).getAPR(_actor);
        bool isWhitelisted = ISanctumWhitelist(whitelist).isApproved(_sanctum);
        bool isOverridden = IPlanetaryOverrideSuite(overrideSuite).isOverrideTriggered(_actor);

        if (apr < 60) {
            emit ValidationFailed(_actor, "Low emotional APR");
            return false;
        }
        if (!isWhitelisted) {
            emit ValidationFailed(_actor, "Sanctum not whitelisted");
            return false;
        }
        if (isOverridden) {
            emit ValidationFailed(_actor, "Override triggered");
            return false;
        }

        emit ValidationPassed(_actor);
        return true;
    }
}
