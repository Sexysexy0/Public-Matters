// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title SovereignWatersSuite
/// @notice Bundled protocols for defending EEZs and rejecting maritime imperialism
import "../defense/EEZIntegrityProtocol.sol";
import "../defense/MaritimeProvocationDetector.sol";
import "../ethics/SovereignWatersSanctum.sol";

contract SovereignWatersSuite {
    EEZIntegrityProtocol public eezProtocol;
    MaritimeProvocationDetector public provocationDetector;
    SovereignWatersSanctum public sanctum;

    constructor() {
        eezProtocol = new EEZIntegrityProtocol();
        provocationDetector = new MaritimeProvocationDetector();
        sanctum = new SovereignWatersSanctum();
    }

    function activateDefense(address violator, string memory location, string memory vessel, string memory nature) public {
        eezProtocol.logViolation(violator, location);
        provocationDetector.logProvocation(vessel, location, nature);
    }

    function doctrine() public view returns (string memory) {
        return sanctum.getDoctrine();
    }
}
