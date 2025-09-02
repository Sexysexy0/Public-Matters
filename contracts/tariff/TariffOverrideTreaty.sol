// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract TariffOverrideTreaty {
    address public steward;
    mapping(string => bool) public overrideApproved;
    event TreatySigned(string clause, bool approved);

    constructor() {
        steward = msg.sender;
    }

    function approveOverride(string memory clause) public {
        require(msg.sender == steward, "Only steward may override");
        overrideApproved[clause] = true;
        emit TreatySigned(clause, true);
    }

    function isApproved(string memory clause) public view returns (bool) {
        return overrideApproved[clause];
    }
}
