// ResetProtocol.sol
pragma solidity ^0.8.0;

contract ResetProtocol {
    struct Reset {
        uint256 id;
        string clause;       // e.g. "Remove self-referencing preaching"
        bool applied;
        uint256 timestamp;
    }

    uint256 public resetCount;
    mapping(uint256 => Reset) public resets;

    event ResetApplied(uint256 id, string clause);

    function applyReset(string memory clause) public {
        resetCount++;
        resets[resetCount] = Reset(resetCount, clause, true, block.timestamp);
        emit ResetApplied(resetCount, clause);
    }
}
