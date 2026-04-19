// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AntiScalperOracle {
    struct Slot {
        bytes32 riderBiometricHash;
        string plateNumber;
        bool isUsed;
    }

    mapping(uint256 => Slot) public subsidySlots;

    // [REPORT: "Bentahan ng ticketing number"]
    function validateAndClaim(uint256 _slotId, bytes32 _presentedBiometric, string memory _plate) public {
        Slot storage slot = subsidySlots[_slotId];
        
        require(!slot.isUsed, "ERROR: Slot already claimed.");
        require(slot.riderBiometricHash == _presentedBiometric, "ERROR: Biometric Mismatch. Scalping detected.");
        require(keccak256(abi.encodePacked(slot.plateNumber)) == keccak256(abi.encodePacked(_plate)), "ERROR: Vehicle Mismatch.");

        slot.isUsed = true;
        // Logic: Trigger automatic fund release to verified wallet
    }
}
