// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChaosContinuum
/// @notice Covenant contract bridging Order-Chaos-Phoenix cycles into perpetual governance stream
contract ChaosContinuum {
    address public owner;

    struct Continuum {
        uint256 arcId;     // linked to OrderChaosPhoenix entry
        string domain;     // e.g. "Explored Territory", "Unknown Chaos", "Reconstituted Order", "Phoenix Regeneration"
        string stream;     // continuum safeguard stream
        uint256 timestamp;
    }

    Continuum[] public streams;

    event Streamed(uint256 arcId, string domain, string stream, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Stream arc into continuum governance
    function streamArc(uint256 arcId, string memory domain, string memory stream) public onlyOwner {
        Continuum memory newStream = Continuum(arcId, domain, stream, block.timestamp);
        streams.push(newStream);
        emit Streamed(arcId, domain, stream, block.timestamp);
    }

    function getStream(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        Continuum memory c = streams[index];
        return (c.arcId, c.domain, c.stream, c.timestamp);
    }

    function getStreamCount() public view returns (uint256) {
        return streams.length;
    }
}
