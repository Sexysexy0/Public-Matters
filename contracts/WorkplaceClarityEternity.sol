// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WorkplaceClarityEternity
/// @notice Covenant contract encoding eternity-level guardianship of PTO respect and organizational clarity
contract WorkplaceClarityEternity {
    address public owner;

    struct Eternity {
        uint256 codexId;   // linked to WorkplaceClarityCodex entry
        string domain;     // e.g. "Organizational Clarity", "Respect for PTO", "Stress Prevention", "Project Planning", "Safeguard Systems"
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

    /// @notice Encode codex safeguard into eternity guardianship
    function vowEternity(uint256 codexId, string memory domain, string memory vow) public onlyOwner {
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
