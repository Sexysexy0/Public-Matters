// EndOfLifeEscrow.sol
pragma solidity ^0.8.0;

contract EndOfLifeEscrow {
    mapping(address => bytes32) private serverSourceCodeHash;
    bool public isSupportEnded;

    function triggerPublicRelease() public {
        // Triggered if the publisher stops heartbeats for > 90 days
        // Automatically makes the game "Open Source" or "Community Hosted"
        isSupportEnded = true;
    }
}
