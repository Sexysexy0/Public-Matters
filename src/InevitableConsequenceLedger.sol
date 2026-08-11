// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title InevitableConsequenceLedger
 * @notice Enforces immutable accountability where every action multiplies its recorded weight.
 */
contract InevitableConsequenceLedger {
    
    struct Record {
        address actor;
        string actionHash;
        uint256 weight;
        uint256 timestamp;
        bool settled;
    }

    mapping(bytes32 => Record) public ledgers;
    mapping(address => uint256) public accountabilityIndex;

    event ActionLogged(address indexed actor, bytes32 indexed actionId, uint256 weight, uint256 timestamp);
    event ConsequenceEnforced(address indexed actor, bytes32 indexed actionId, uint256 penalty);

    /**
     * @notice Logs an action, tying it permanently to the actor with an inescapable weight.
     */
    function logAction(string memory _actionHash, uint256 _weight) external returns (bytes32) {
        bytes32 actionId = keccak256(abi.encodePacked(msg.sender, _actionHash, block.timestamp));
        
        ledgers[actionId] = Record({
            actor: msg.sender,
            actionHash: _actionHash,
            weight: _weight,
            timestamp: block.timestamp,
            settled: false
        });

        // Consequences multiply over time or usage
        accountabilityIndex[msg.sender] += _weight * 2;

        emit ActionLogged(msg.sender, actionId, _weight, block.timestamp);
        return actionId;
    }

    /**
     * @notice Settles the record permanently. Reality cannot be cheated; balance must be met.
     */
    function settleLedger(bytes32 _actionId) external {
        Record storage rec = ledgers[_actionId];
        require(msg.sender == rec.actor, "Unauthorized settlement");
        require(!rec.settled, "Already settled");

        rec.settled = true;
        emit ConsequenceEnforced(rec.actor, _actionId, rec.weight);
    }
}
