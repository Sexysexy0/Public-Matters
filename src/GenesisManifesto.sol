// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GenesisManifesto
 * @dev The origin story of the kingdom, encoded on‑chain for eternity.
 */
contract GenesisManifesto {
    string public manifest;
    uint256 public timestamp;
    address public immutable author;

    event ManifestRecorded(string manifest, uint256 timestamp);

    constructor(string memory _manifest) {
        author = msg.sender;
        manifest = _manifest;
        timestamp = block.timestamp;
        emit ManifestRecorded(_manifest, block.timestamp);
    }

    function getManifest() external view returns (string memory, uint256, address) {
        return (manifest, timestamp, author);
    }
}
