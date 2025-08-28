// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title MaritimeProvocationDetector
/// @notice Logs hostile maritime acts as provocation events
contract MaritimeProvocationDetector {
    event ProvocationLogged(string vesselName, string location, string nature, uint256 timestamp);

    function logProvocation(
        string memory vesselName,
        string memory location,
        string memory nature
    ) public {
        emit ProvocationLogged(vesselName, location, nature, block.timestamp);
    }
}
