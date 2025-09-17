// SPDX-License-Identifier: ContextSanctum
pragma solidity ^0.8.19;

contract AIContextIntegrityRouter {
    address public steward;

    struct ContextSource {
        string sourceTag; // e.g. "GitHub Repo", "Tweet", "API Response"
        string riskSignal; // e.g. "Poisoned", "Verified", "Unknown"
        bool verified;
        uint256 timestamp;
    }

    ContextSource[] public sources;

    event ContextLogged(string sourceTag, string riskSignal, uint256 timestamp);
    event ContextVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logContext(
        string memory sourceTag,
        string memory riskSignal
    ) public {
        sources.push(ContextSource(sourceTag, riskSignal, false, block.timestamp));
        emit ContextLogged(sourceTag, riskSignal, block.timestamp);
    }

    function verifyContext(uint256 index) public {
        require(index < sources.length, "Invalid index");
        sources[index].verified = true;
        emit ContextVerified(index, msg.sender);
    }

    function getContext(uint256 index) public view returns (
        string memory, string memory, bool, uint256
    ) {
        ContextSource memory c = sources[index];
        return (c.sourceTag, c.riskSignal, c.verified, c.timestamp);
    }

    function totalContexts() public view returns (uint256) {
        return sources.length;
    }
}
