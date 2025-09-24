// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./GlobalComplianceRegistry.sol";

/// @title FallbackValidator
/// @notice Validates donation corridors and auto-triggers fallback routes
/// @dev Works with GlobalComplianceRegistry to enforce damay clause in real time
contract FallbackValidator {
    GlobalComplianceRegistry public registry;
    address public steward;

    event CorridorChecked(
        string fromIso,
        GlobalComplianceRegistry.AssetClass asset,
        bool permitted,
        string reason
    );

    event FallbackEngaged(
        string fromIso,
        string toIso,
        GlobalComplianceRegistry.AssetClass asset,
        string reason
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address registryAddress) {
        registry = GlobalComplianceRegistry(registryAddress);
        steward = msg.sender;
    }

    /// @notice Validate a corridor; if blocked, auto-engage fallback
    function validateWithFallback(
        string memory fromIso,
        GlobalComplianceRegistry.AssetClass asset
    ) external onlySteward returns (bool permitted, string memory reason, string memory fallbackIso) {
        (bool ok, string memory why) = registry.validateCorridor(fromIso, asset);

        if (ok) {
            emit CorridorChecked(fromIso, asset, true, why);
            return (true, why, "");
        }

        // Try fallback
        (bytes32 fbKey, string memory fbWhy) = registry.findFallback(asset);
        if (fbKey == bytes32(0)) {
            emit CorridorChecked(fromIso, asset, false, why);
            return (false, why, "");
        }

        // Convert bytes32 key back to string for broadcast
        string memory fbIso = _bytes32ToString(fbKey);
        emit FallbackEngaged(fromIso, fbIso, asset, fbWhy);
        return (false, why, fbIso);
    }

    /// @dev Helper to convert bytes32 key back to string (ISO code)
    function _bytes32ToString(bytes32 _bytes32) internal pure returns (string memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (uint8 j = 0; j < i; j++) {
            bytesArray[j] = _bytes32[j];
        }
        return string(bytesArray);
    }
}
