// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SovereignRegistry
/// @notice Central index for all Public-Matters contracts
/// @dev Maps contract addresses to metadata (name, category, version, status)

contract SovereignRegistry {
    address public registrar;
    
    struct ContractMeta {
        string name;
        string category;
        string version;
        address contractAddress;
        bool active;
        uint256 registeredAt;
    }
    
    mapping(address => ContractMeta) public registry;
    mapping(string => address[]) public categoryIndex;
    mapping(bytes32 => bool) public nameExists;
    address[] public allContracts;
    
    event ContractRegistered(address indexed contractAddress, string name, string category);
    event ContractUpdated(address indexed contractAddress, bool active);
    event RegistrarTransferred(address indexed oldRegistrar, address indexed newRegistrar);
    
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
        require(_contract != address(0), "Invalid address");
        require(bytes(_name).length > 0, "Empty name");
        require(registry[_contract].contractAddress == address(0), "Already registered");
        require(!nameExists[keccak256(bytes(_name))], "Name taken");
        
        ContractMeta memory meta = ContractMeta({
            name: _name,
            category: _category,
            version: _version,
            contractAddress: _contract,
            active: true,
            registeredAt: block.timestamp
        });
        
        registry[_contract] = meta;
        nameExists[keccak256(bytes(_name))] = true;
        categoryIndex[_category].push(_contract);
        allContracts.push(_contract);
        
        emit ContractRegistered(_contract, _name, _category);
    }
    
    function registerBatch(
        address[] calldata _contracts,
        string[] calldata _names,
        string[] calldata _categories,
        string[] calldata _versions
    ) external onlyRegistrar {
        uint256 len = _contracts.length;
        require(
            len == _names.length &&
            len == _categories.length &&
            len == _versions.length,
            "Array length mismatch"
        );
        require(len <= 100, "Batch too large");
        
        for (uint256 i = 0; i < len; i++) {
            address addr = _contracts[i];
            string memory name = _names[i];
            
            if (addr != address(0) && 
                bytes(name).length > 0 &&
                registry[addr].contractAddress == address(0) &&
                !nameExists[keccak256(bytes(name))]) {
                
                ContractMeta memory meta = ContractMeta({
                    name: name,
                    category: _categories[i],
                    version: _versions[i],
                    contractAddress: addr,
                    active: true,
                    registeredAt: block.timestamp
                });
                
                registry[addr] = meta;
                nameExists[keccak256(bytes(name))] = true;
                categoryIndex[_categories[i]].push(addr);
                allContracts.push(addr);
                
                emit ContractRegistered(addr, name, _categories[i]);
            }
        }
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
        address old = registrar;
        registrar = _newRegistrar;
        emit RegistrarTransferred(old, _newRegistrar);
    }
}
