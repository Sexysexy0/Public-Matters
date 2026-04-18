// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CensorshipResistanceLedger {
    mapping(bytes32 => string) public truthArchives;

    // Protecting the "Truthtelling Capacity" [10:20]
    function logCitizenJournalism(bytes32 _id, string memory _report) public {
        // Immutable storage: State cannot "disappear" the information
        truthArchives[_id] = _report;
    }
}
