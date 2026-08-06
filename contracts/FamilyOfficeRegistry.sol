// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FamilyOfficeRegistry
 * @dev Master census of PwC entities, family offices, and treaty partners
 */
contract FamilyOfficeRegistry {
    
    enum Jurisdiction { APAC, EU, US, AFRICA, OTHER }

    struct Office {
        string name;              // Pangalan ng entity
        Jurisdiction location;    // Rehiyon (APAC, EU, etc.)
        bytes32 contactHash;      // Hash ng confidential PwC document
        bool isActive;            // Status ng partnership
        uint256 registeredAt;     // Unix timestamp ng registration
    }

    address public immutable owner; // Ikaw, ang One Man Army
    uint256 public officeCount;     // Total bilang ng na-rehistro

    mapping(uint256 => Office) public offices;

    event OfficeRegistered(uint256 indexed id, string name, Jurisdiction location, uint256 timestamp);
    event OfficeUpdated(uint256 indexed id, bytes32 newHash);
    event OfficeDeactivated(uint256 indexed id, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "FamilyOfficeRegistry: Only the owner can operate");
        _;
    }

    constructor() {
        owner = msg.sender; // Itinatali ang deployer bilang ang nag-iisang operator
    }

    // Magdagdag ng bagong Family Office / PwC Entity
    function registerOffice(
        string memory _name,
        Jurisdiction _location,
        bytes32 _contactHash
    ) external onlyOwner {
        officeCount++;
        offices[officeCount] = Office({
            name: _name,
            location: _location,
            contactHash: _contactHash,
            isActive: true,
            registeredAt: block.timestamp
        });
        emit OfficeRegistered(officeCount, _name, _location, block.timestamp);
    }

    // I-update ang PwC document hash (kung may bagong version)
    function updateOfficeHash(uint256 _id, bytes32 _newHash) external onlyOwner {
        require(offices[_id].isActive, "FamilyOfficeRegistry: Entity is inactive");
        offices[_id].contactHash = _newHash;
        emit OfficeUpdated(_id, _newHash);
    }

    // I-deactivate ang partnership (kung natapos na ang treaty o PPP)
    function deactivateOffice(uint256 _id) external onlyOwner {
        require(offices[_id].isActive, "FamilyOfficeRegistry: Already inactive");
        offices[_id].isActive = false;
        emit OfficeDeactivated(_id, block.timestamp);
    }

    // Tingnan ang detalye ng isang entity (Public view function)
    function getOffice(uint256 _id) external view returns (Office memory) {
        return offices[_id];
    }
}
