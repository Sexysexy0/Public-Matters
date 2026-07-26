// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SovereignRegistry
/// @notice Central index for all Public-Matters contracts
/// @dev Maps contract addresses to metadata (name, category, version, status)

contract SovereignRegistry {
    address public registrar;
    
    struct ContractMeta {
        string name;
        string category;      // e.g., "finance", "water", "safeguards"
        string version;
        address contractAddress;
        bool active;
        uint256 registeredAt;
    }
    
    mapping(address => ContractMeta) public registry;
    mapping(string => address[]) public categoryIndex;
    address[] public allContracts;
    
    event ContractRegistered(address indexed contractAddress, string name, string category);
    event ContractUpdated(address indexed contractAddress, bool active);
    
    modifier onlyRegistrar() {
        require(msg.sender == registrar, "Not registrar");
        _;
    }
    
    constructor() {
        registrar = msg.sender;
    }
    
    function register(
        address _contract,
        string memory _name,
        string memory _category,
        string memory _version
    ) external onlyRegistrar {
        require(registry[_contract].contractAddress == address(0), "Already registered");
        
        ContractMeta memory meta = ContractMeta({
            name: _name,
            category: _category,
            version: _version,
            contractAddress: _contract,
            active: true,
            registeredAt: block.timestamp
        });
        
        registry[_contract] = meta;
        categoryIndex[_category].push(_contract);
        allContracts.push(_contract);
        
        emit ContractRegistered(_contract, _name, _category);
    }
    
    function setActive(address _contract, bool _active) external onlyRegistrar {
        require(registry[_contract].contractAddress != address(0), "Not registered");
        registry[_contract].active = _active;
        emit ContractUpdated(_contract, _active);
    }
    
    function getByCategory(string memory _category) external view returns (address[] memory) {
        return categoryIndex[_category];
    }
    
    function getAll() external view returns (address[] memory) {
        return allContracts;
    }
    
    function count() external view returns (uint256) {
        return allContracts.length;
    }
    
    function getMeta(address _contract) external view returns (ContractMeta memory) {
        return registry[_contract];
    }
    
    function transferRegistrar(address _newRegistrar) external onlyRegistrar {
        require(_newRegistrar != address(0), "Invalid address");
        registrar = _newRegistrar;
    }
}
