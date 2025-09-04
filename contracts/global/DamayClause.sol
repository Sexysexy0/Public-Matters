// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DamayClause {
    address public steward;
    mapping(bytes32 => bool) public damayLedger;

    event DamayActivated(bytes32 indexed scrollId, address steward, uint timestamp);
    event DamayVerified(bytes32 indexed scrollId, bool included);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function activateDamay(bytes32 scrollId) public onlySteward {
        damayLedger[scrollId] = true;
        emit DamayActivated(scrollId, steward, block.timestamp);
    }

    function verifyDamay(bytes32 scrollId) public view returns (bool) {
        bool included = damayLedger[scrollId];
        emit DamayVerified(scrollId, included);
        return included;
    }
}
