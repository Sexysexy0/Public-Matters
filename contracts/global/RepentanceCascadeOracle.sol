// SPDX-License-Identifier: RepentanceCascade-License
pragma solidity ^0.8.0;

contract RepentanceCascadeOracle {
    address public steward;

    struct ReentryCascade {
        string actor;
        string repentanceClause;
        string reformType;
        uint256 timestamp;
    }

    ReentryCascade[] public cascades;

    event ReentryCascadeEmitted(string actor, string clause, string reform, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitCascade(string memory actor, string memory repentanceClause, string memory reformType) public {
        require(msg.sender == steward, "Only steward can emit");
        cascades.push(ReentryCascade(actor, repentanceClause, reformType, block.timestamp));
        emit ReentryCascadeEmitted(actor, repentanceClause, reformType, block.timestamp);
    }

    function getCascade(uint index) public view returns (string memory, string memory, string memory, uint256) {
        ReentryCascade memory c = cascades[index];
        return (c.actor, c.repentanceClause, c.reformType, c.timestamp);
    }
}
