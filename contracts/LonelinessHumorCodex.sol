// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LonelinessHumorCodex
/// @notice Covenant contract encoding humor safeguards and social resonance
contract LonelinessHumorCodex {
    address public owner;

    struct Humor {
        uint256 postId;   // linked to social post
        string domain;    // e.g. "Male Loneliness", "Humor", "Dark Romance", "Edgy Identity"
        string safeguard; // humor safeguard decree
        uint256 timestamp;
    }

    Humor[] public humors;

    event Safeguarded(uint256 postId, string domain, string safeguard, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Encode humorous post into covenant safeguard
    function safeguardHumor(uint256 postId, string memory domain, string memory safeguard) public onlyOwner {
        Humor memory newHumor = Humor(postId, domain, safeguard, block.timestamp);
        humors.push(newHumor);
        emit Safeguarded(postId, domain, safeguard, block.timestamp);
    }

    function getHumor(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        Humor memory h = humors[index];
        return (h.postId, h.domain, h.safeguard, h.timestamp);
    }

    function getHumorCount() public view returns (uint256) {
        return humors.length;
    }
}
