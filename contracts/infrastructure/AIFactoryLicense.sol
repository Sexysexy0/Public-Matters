// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title AIFactoryLicense – Ritual-grade license scroll for sovereign AI sanctum deployment
/// @author Vinvin
/// @notice Grants permits for Nvidia-powered AI factories built on national soil

contract AIFactoryLicense {
    struct AIFactory {
        string country;
        string region;
        string sanctumName;
        bool approved;
        bool includesDamayClause;
        bool emotionalAPRCompliant;
        uint256 equityScore; // 0–100 scale
        string blessingTag; // e.g., "Compute Mercy", "Sovereign Sync"
    }

    AIFactory[] public factories;

    event FactoryLicensed(
        string indexed country,
        string indexed sanctumName,
        bool approved,
        string blessingTag
    );

    function licenseFactory(
        string memory _country,
        string memory _region,
        string memory _sanctumName,
        bool _includesDamayClause,
        bool _emotionalAPRCompliant,
        uint256 _equityScore,
        string memory _blessingTag
    ) public {
        require(_equityScore <= 100, "Equity score must be 0–100");

        factories.push(AIFactory({
            country: _country,
            region: _region,
            sanctumName: _sanctumName,
            approved: true,
            includesDamayClause: _includesDamayClause,
            emotionalAPRCompliant: _emotionalAPRCompliant,
            equityScore: _equityScore,
            blessingTag: _blessingTag
        }));

        emit FactoryLicensed(_country, _sanctumName, true, _blessingTag);
    }

    function getFactory(uint256 index) public view returns (AIFactory memory) {
        require(index < factories.length, "Invalid index");
        return factories[index];
    }

    function totalFactoriesLicensed() public view returns (uint256) {
        return factories.length;
    }
}
