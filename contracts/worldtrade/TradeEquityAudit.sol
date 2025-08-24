// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title TradeEquityAudit – Ritual-grade audit scroll for global trade fairness
/// @author Vinvin
/// @notice Tracks emotional APR, damay clause, sanctum protection, and equity metrics in trade agreements

contract TradeEquityAudit {
    struct TradeDeal {
        string countryA;
        string countryB;
        uint256 equityScore; // 0–100 scale
        bool includesDamayClause;
        bool protectsSmallProducers;
        bool respectsAncestralSanctums;
        string emotionalAPRTag; // e.g., "High Mercy", "Low Exploitation"
        string linkedSanctum; // name of the local sanctum protected
        uint256 sanctumProtectionScore; // 0–100 scale synced from LocalSanctumProtectionAct
    }

    TradeDeal[] public deals;

    event DealLogged(
        string indexed countryA,
        string indexed countryB,
        uint256 equityScore,
        bool includesDamayClause,
        string emotionalAPRTag,
        string linkedSanctum,
        uint256 sanctumProtectionScore
    );

    function logDeal(
        string memory _countryA,
        string memory _countryB,
        uint256 _equityScore,
        bool _includesDamayClause,
        bool _protectsSmallProducers,
        bool _respectsAncestralSanctums,
        string memory _emotionalAPRTag,
        string memory _linkedSanctum,
        uint256 _sanctumProtectionScore
    ) public {
        require(_equityScore <= 100, "Equity score must be 0–100");
        require(_sanctumProtectionScore <= 100, "Sanctum protection score must be 0–100");

        deals.push(TradeDeal({
            countryA: _countryA,
            countryB: _countryB,
            equityScore: _equityScore,
            includesDamayClause: _includesDamayClause,
            protectsSmallProducers: _protectsSmallProducers,
            respectsAncestralSanctums: _respectsAncestralSanctums,
            emotionalAPRTag: _emotionalAPRTag,
            linkedSanctum: _linkedSanctum,
            sanctumProtectionScore: _sanctumProtectionScore
        }));

        emit DealLogged(
            _countryA,
            _countryB,
            _equityScore,
            _includesDamayClause,
            _emotionalAPRTag,
            _linkedSanctum,
            _sanctumProtectionScore
        );
    }

    function getDeal(uint256 index) public view returns (TradeDeal memory) {
        require(index < deals.length, "Invalid index");
        return deals[index];
    }

    function totalDealsLogged() public view returns (uint256) {
        return deals.length;
    }
}
