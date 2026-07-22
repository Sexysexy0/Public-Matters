// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyRegistry
/// @notice Covenant contract to log and expose asset declarations for public accountability
contract TransparencyRegistry {
    address public sovereignContractor;

    struct Declaration {
        uint256 id;
        address declarant;
        string assetType;
        uint256 value;
        bool verified;
    }

    mapping(uint256 => Declaration) public declarations;
    uint256 public totalDeclarations;

    event AssetDeclared(uint256 indexed id, address indexed declarant, string assetType, uint256 value, bool verified);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    /// @notice Register an asset declaration
    function declareAsset(string memory _assetType, uint256 _value) public returns (uint256) {
        totalDeclarations++;
        declarations[totalDeclarations] = Declaration(totalDeclarations, msg.sender, _assetType, _value, false);
        emit AssetDeclared(totalDeclarations, msg.sender, _assetType, _value, false);
        return totalDeclarations;
    }

    /// @notice Verify a declaration (contractor only)
    function verifyDeclaration(uint256 id) public onlyContractor {
        declarations[id].verified = true;
    }

    /// @notice Fetch declaration details
    function getDeclaration(uint256 id) public view returns (Declaration memory) {
        return declarations[id];
    }
}
