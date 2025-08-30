// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SanctionedFXAudit
/// @notice Flags and audits foreign exchange pairs with geopolitical, ethical, or emotional APR breaches
contract SanctionedFXAudit {
    struct FXPair {
        string baseCurrency;
        string quoteCurrency;
        bool isSanctioned;
        string reason;
        uint256 timestamp;
    }

    mapping(bytes32 => FXPair) public fxPairs;
    event FXPairFlagged(string baseCurrency, string quoteCurrency, string reason, uint256 timestamp);
    event FXPairCleared(string baseCurrency, string quoteCurrency, uint256 timestamp);

    /// @notice Flags an FX pair as sanctioned
    function flagFXPair(string memory base, string memory quote, string memory reason) public {
        bytes32 pairId = keccak256(abi.encodePacked(base, quote));
        fxPairs[pairId] = FXPair(base, quote, true, reason, block.timestamp);
        emit FXPairFlagged(base, quote, reason, block.timestamp);
    }

    /// @notice Clears an FX pair from sanction list
    function clearFXPair(string memory base, string memory quote) public {
        bytes32 pairId = keccak256(abi.encodePacked(base, quote));
        require(fxPairs[pairId].isSanctioned, "Pair not sanctioned");
        fxPairs[pairId].isSanctioned = false;
        fxPairs[pairId].reason = "Cleared by steward";
        fxPairs[pairId].timestamp = block.timestamp;
        emit FXPairCleared(base, quote, block.timestamp);
    }

    /// @notice Checks if an FX pair is sanctioned
    function isSanctioned(string memory base, string memory quote) public view returns (bool) {
        bytes32 pairId = keccak256(abi.encodePacked(base, quote));
        return fxPairs[pairId].isSanctioned;
    }

    /// @notice Retrieves full audit log of an FX pair
    function getAuditLog(string memory base, string memory quote) public view returns (FXPair memory) {
        bytes32 pairId = keccak256(abi.encodePacked(base, quote));
        return fxPairs[pairId];
    }
}
