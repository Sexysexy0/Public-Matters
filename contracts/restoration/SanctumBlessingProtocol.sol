// SPDX-License-Identifier: Mythic-7
pragma solidity ^0.8.19;

/// @title SanctumBlessingProtocol.sol
/// @notice Certifies hospitals and clinics with barangay-blessed, mythic-grade status
contract SanctumBlessingProtocol {
    address public steward;

    struct Sanctum {
        string name;
        string barangay;
        bool blessed;
        uint256 timestamp;
    }

    Sanctum[] public sanctums;

    event SanctumBlessed(string name, string barangay, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blessSanctum(string memory name, string memory barangay) public onlySteward {
        sanctums.push(Sanctum(name, barangay, true, block.timestamp));
        emit SanctumBlessed(name, barangay, block.timestamp);
    }

    function getSanctum(uint256 index) public view returns (Sanctum memory) {
        require(index < sanctums.length, "Sanctum not found");
        return sanctums[index];
    }

    function totalSanctums() public view returns (uint256) {
        return sanctums.length;
    }
}
