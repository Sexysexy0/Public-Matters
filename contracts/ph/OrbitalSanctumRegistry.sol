// SPDX-License-Identifier: Orbital-Registry
pragma solidity ^0.8.20;

/// @title OrbitalSanctumRegistry.sol
/// @dev Logs fallback HQs for planetary defense and cultural resilience

contract OrbitalSanctumRegistry {
    address public stewardVinvin;

    struct OrbitalSanctum {
        string company;
        string fallbackLocation;
        string orbitalPurpose;
        string culturalTag;
        bool registered;
    }

    OrbitalSanctum[] public registry;

    event SanctumRegistered(string company, string location, string orbitalPurpose);

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function registerSanctum(string memory company, string memory location, string memory purpose, string memory tag) public onlyVinvin {
        registry.push(OrbitalSanctum(company, location, purpose, tag, true));
        emit SanctumRegistered(company, location, purpose);
    }

    function getRegistry() public view returns (OrbitalSanctum[] memory) {
        return registry;
    }
}
