// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title NavalVesselRegistry
 * @notice On-chain registry for player ships, interior customization, and base actions.
 *         Allows ships to act as mobile bases (sleep, cook, craft, store cargo).
 */
contract NavalVesselRegistry {
    OperatorPrivileges public immutable privileges;

    enum RoomType { BEDROOM, GALLEY, ARMORY, CARGO_HOLD }
    
    struct Vessel {
        address owner;
        uint8 shipClass; // 0 = Small (no interior), 1 = Large (full interior)
        bool exists;
    }

    struct Room {
        bool unlocked;
        bytes32 customizationHash;
        uint256 upgradeLevel;
    }

    mapping(bytes32 => Vessel) public vessels;
    mapping(bytes32 => mapping(RoomType => Room)) public rooms;
    mapping(bytes32 => mapping(bytes32 => uint256)) public cargo; // shipId => itemHash => qty
    
    event VesselRegistered(bytes32 indexed shipId, address indexed owner, uint8 shipClass);
    event RoomCustomized(bytes32 indexed shipId, RoomType roomType, bytes32 customizationHash);
    event PlayerRested(bytes32 indexed shipId, address indexed player);
    event MealCooked(bytes32 indexed shipId, bytes32 recipeHash);
    event GearCrafted(bytes32 indexed shipId, bytes32 gearHash);
    event CargoDeposited(bytes32 indexed shipId, bytes32 itemHash, uint256 amount);
    event CargoWithdrawn(bytes32 indexed shipId, bytes32 itemHash, uint256 amount);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    modifier onlyOwner(bytes32 shipId) {
        require(vessels[shipId].owner == msg.sender, "Not ship owner");
        _;
    }

    modifier requireRoom(bytes32 shipId, RoomType rt) {
        require(rooms[shipId][rt].unlocked, "Room not unlocked");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    // ── Ship Management ──

    function registerVessel(bytes32 shipId, address owner, uint8 shipClass) external onlyOperator {
        require(!vessels[shipId].exists, "Ship exists");
        vessels[shipId] = Vessel({ owner: owner, shipClass: shipClass, exists: true });
        
        // Small ships (0) only have cargo. Large ships (1) get all rooms.
        if (shipClass >= 1) {
            rooms[shipId][RoomType.BEDROOM].unlocked = true;
            rooms[shipId][RoomType.GALLEY].unlocked = true;
            rooms[shipId][RoomType.ARMORY].unlocked = true;
        }
        rooms[shipId][RoomType.CARGO_HOLD].unlocked = true;

        emit VesselRegistered(shipId, owner, shipClass);
    }

    // ── Interior Customization ──

    function customizeRoom(bytes32 shipId, RoomType rt, bytes32 customizationHash) 
        external onlyOwner(shipId) 
    {
        require(rooms[shipId][rt].unlocked, "Room not unlocked");
        rooms[shipId][rt].customizationHash = customizationHash;
        emit RoomCustomized(shipId, rt, customizationHash);
    }

    // ── Base Actions ──

    /// @notice Sleep on the existing beds.
    function restInBedroom(bytes32 shipId) 
        external onlyOwner(shipId) requireRoom(shipId, RoomType.BEDROOM) 
    {
        emit PlayerRested(shipId, msg.sender);
    }

    /// @notice Cook below deck.
    function cookInGalley(bytes32 shipId, bytes32 recipeHash) 
        external onlyOwner(shipId) requireRoom(shipId, RoomType.GALLEY) 
    {
        emit MealCooked(shipId, recipeHash);
    }

    /// @notice Craft and refine gear.
    function craftInArmory(bytes32 shipId, bytes32 gearHash) 
        external onlyOwner(shipId) requireRoom(shipId, RoomType.ARMORY) 
    {
        emit GearCrafted(shipId, gearHash);
    }

    // ── Cargo Hold ──

    function depositCargo(bytes32 shipId, bytes32 itemHash, uint256 amount) 
        external onlyOwner(shipId) requireRoom(shipId, RoomType.CARGO_HOLD) 
    {
        require(amount > 0, "amount=0");
        cargo[shipId][itemHash] += amount;
        emit CargoDeposited(shipId, itemHash, amount);
    }

    function withdrawCargo(bytes32 shipId, bytes32 itemHash, uint256 amount) 
        external onlyOwner(shipId) requireRoom(shipId, RoomType.CARGO_HOLD) 
    {
        require(cargo[shipId][itemHash] >= amount, "Insufficient cargo");
        cargo[shipId][itemHash] -= amount;
        emit CargoWithdrawn(shipId, itemHash, amount);
    }

    // ── Views ──

    function getCargo(bytes32 shipId, bytes32 itemHash) external view returns (uint256) {
        return cargo[shipId][itemHash];
    }
    
    function getRoomStatus(bytes32 shipId, RoomType rt) external view returns (Room memory) {
        return rooms[shipId][rt];
    }
}
