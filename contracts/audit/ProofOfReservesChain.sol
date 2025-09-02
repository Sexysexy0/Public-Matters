// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.19;

/// @title ProofOfReservesChain
/// @notice Verifies exchange solvency using on-chain assets and declared liabilities
/// @dev Includes emotional APR telemetry and damay clause for multi-exchange solidarity

contract ProofOfReservesChain {
    struct ExchangeProfile {
        uint256 onChainAssets;
        uint256 declaredLiabilities;
        uint256 emotionalAPR; // Trust metric (0–100)
        bool damayClauseActive;
    }

    mapping(address => ExchangeProfile) public exchanges;

    event ReservesVerified(address indexed exchange, bool isSolvent, uint256 emotionalAPR);
    event DamayTriggered(address indexed exchange, string message);

    /// @notice Registers or updates an exchange profile
    function updateExchangeProfile(
        address exchange,
        uint256 assets,
        uint256 liabilities,
        uint256 apr,
        bool damay
    ) external {
        exchanges[exchange] = ExchangeProfile(assets, liabilities, apr, damay);
    }

    /// @notice Verifies solvency of an exchange
    function verifyReserves(address exchange) external returns (bool) {
        ExchangeProfile memory profile = exchanges[exchange];
        bool isSolvent = profile.onChainAssets >= profile.declaredLiabilities;

        emit ReservesVerified(exchange, isSolvent, profile.emotionalAPR);

        if (!isSolvent && profile.damayClauseActive) {
            emit DamayTriggered(exchange, "Damay clause activated: Notify kin exchanges and validators.");
        }

        return isSolvent;
    }

    /// @notice Returns emotional APR of an exchange
    function getEmotionalAPR(address exchange) external view returns (uint256) {
        return exchanges[exchange].emotionalAPR;
    }

    /// @notice Returns damay clause status
    function isDamayActive(address exchange) external view returns (bool) {
        return exchanges[exchange].damayClauseActive;
    }
}
