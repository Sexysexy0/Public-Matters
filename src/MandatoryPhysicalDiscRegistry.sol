// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MandatoryPhysicalDiscRegistry {
    struct DiscLicense {
        bytes32 physicalChipHash;
        address currentOwner;
        bool isOfflineActivated;
        uint256 registeredTimestamp;
    }

    mapping(uint256 => DiscLicense) public discRegistry;
    mapping(bytes32 => bool) public registeredChipHashes;

    event PhysicalDiscLinked(uint256 indexed tokenId, bytes32 indexed chipHash, address indexed owner);
    event LicenseTransferred(uint256 indexed tokenId, address from, address to);

    function registerPhysicalDisc(uint256 tokenId, bytes32 chipHash) external {
        require(!registeredChipHashes[chipHash], "Chip hash already registered");
        require(discRegistry[tokenId].currentOwner == address(0), "Token ID already linked");

        discRegistry[tokenId] = DiscLicense({
            physicalChipHash: chipHash,
            currentOwner: msg.sender,
            isOfflineActivated: true,
            registeredTimestamp: block.timestamp
        });

        registeredChipHashes[chipHash] = true;
        emit PhysicalDiscLinked(tokenId, chipHash, msg.sender);
    }

    function transferPhysicalLicense(uint256 tokenId, address newOwner, bytes32 chipHashProof) external {
        DiscLicense storage license = discRegistry[tokenId];
        require(license.currentOwner == msg.sender, "Not the owner");
        require(license.physicalChipHash == chipHashProof, "Physical chip verification failed");

        address previousOwner = license.currentOwner;
        license.currentOwner = newOwner;

        emit LicenseTransferred(tokenId, previousOwner, newOwner);
    }
}
