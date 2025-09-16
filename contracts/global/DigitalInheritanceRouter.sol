// SPDX-License-Identifier: LegacySanctum
pragma solidity ^0.8.19;

contract DigitalInheritanceRouter {
    struct InheritanceSignal {
        address assetOwner;
        string assetType; // e.g., "NFT", "Token", "GameSkin", "Domain"
        address heir;
        uint256 unlockDate;
        bool verified;
        string stewardNote;
    }

    mapping(address => InheritanceSignal) public inheritanceRegistry;

    event InheritanceTagged(address assetOwner, address heir);
    event InheritanceVerified(address assetOwner);

    function tagInheritance(address assetOwner, string memory assetType, address heir, uint256 unlockDate, string memory stewardNote) public {
        inheritanceRegistry[assetOwner] = InheritanceSignal(assetOwner, assetType, heir, unlockDate, false, stewardNote);
        emit InheritanceTagged(assetOwner, heir);
    }

    function verifyInheritance(address assetOwner) public {
        require(bytes(inheritanceRegistry[assetOwner].assetType).length > 0, "No inheritance tagged");
        inheritanceRegistry[assetOwner].verified = true;
        emit InheritanceVerified(assetOwner);
    }

    function getInheritanceStatus(address assetOwner) public view returns (InheritanceSignal memory) {
        return inheritanceRegistry[assetOwner];
    }
}
