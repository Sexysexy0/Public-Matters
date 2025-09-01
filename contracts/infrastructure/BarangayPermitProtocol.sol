// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract BarangayPermitProtocol {
    mapping(string => bool) public permits;

    event PermitGranted(string barangay);
    event PermitRevoked(string barangay);

    function grantPermit(string memory barangay) public {
        permits[barangay] = true;
        emit PermitGranted(barangay);
    }

    function revokePermit(string memory barangay) public {
        permits[barangay] = false;
        emit PermitRevoked(barangay);
    }

    function isPermitted(string memory barangay) public view returns (bool) {
        return permits[barangay];
    }
}
