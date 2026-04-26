// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UniversalAidLedger {
    event AidSeal(string barangay, string status);

    function logAid(string memory _barangay, string memory _status) external {
        emit AidSeal(_barangay, _status);
        // RULE: Aid distribution must include all barangays.
    }
}
