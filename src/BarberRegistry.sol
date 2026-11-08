// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

contract BarberRegistry {
    OperatorPrivileges public immutable privileges;
    
    struct HairStyle {
        bytes32 styleHash;
        uint256 price;
        bool available;
    }
    
    mapping(bytes32 => HairStyle) public styles;
    mapping(bytes32 => bytes32) public currentStyle; // characterId => styleHash
    
    event HairStyleAdded(bytes32 indexed styleHash, uint256 price);
    event HaircutApplied(bytes32 indexed characterId, bytes32 indexed styleHash);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function addHairStyle(bytes32 styleHash, uint256 price) external onlyOperator {
        require(!styles[styleHash].available, "Style exists");
        styles[styleHash] = HairStyle({
            styleHash: styleHash,
            price: price,
            available: true
        });
        emit HairStyleAdded(styleHash, price);
    }

    function applyHaircut(bytes32 characterId, bytes32 styleHash) external onlyOperator {
        require(styles[styleHash].available, "Style not available");
        currentStyle[characterId] = styleHash;
        emit HaircutApplied(characterId, styleHash);
    }
}
