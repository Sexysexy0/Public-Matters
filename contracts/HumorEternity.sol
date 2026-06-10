// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HumorEternity
/// @notice Covenant contract encoding eternity-level guardianship of humor and edgy resonance
contract HumorEternity {
    address public owner;

    struct Eternity {
        uint256 codexId;   // linked to LonelinessHumorCodex entry
        string domain;     // e.g. "Humor", "Irony", "Edgy Resonance", "Cultural Continuity"
        string vow;        // eternity safeguard vow
        uint256 timestamp;
    }

    Eternity[] public vows;

    event Vowed(uint256 codexId, string domain, string vow, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Encode humor codex into eternity guardianship
    function vowHumor(uint256 codexId, string memory domain, string memory vow) public onlyOwner {
        Eternity memory newVow = Eternity(codexId, domain, vow, block.timestamp);
        vows.push(newVow);
        emit Vowed(codexId, domain, vow, block.timestamp);
    }

    function getVow(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        Eternity memory e = vows[index];
        return (e.codexId, e.domain, e.vow, e.timestamp);
    }

    function getVowCount() public view returns (uint256) {
        return vows.length;
    }
}
