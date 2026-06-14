// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IPClaimRegistry {
    address public guardian;
    uint256 public totalClaims;

    struct IPClaim {
        uint256 id;
        bytes32 ipHash;          // Cryptographic footprint ng code blueprint o asset logic
        string assetName;        // Pormal na pangalan ng system asset
        address registeredOwner; // Ang orihinal na nagmamay-ari o nag-rehistro ng asset
        bool isVerified;         // Estado ng verification mula sa Guardian
        uint256 timestamp;       // Oras ng pagpapatala
    }

    mapping(uint256 => IPClaim) public claims;
    mapping(bytes32 => bool) public ipExists;
    mapping(bytes32 => mapping(address => bool)) public authorizedUsers;

    event IPCreated(uint256 indexed claimId, bytes32 indexed ipHash, address indexed owner, string assetName);
    event IPVerified(uint256 indexed claimId, bool status);
    event AccessGranted(bytes32 indexed ipHash, address indexed user);
    event AccessRevoked(bytes32 indexed ipHash, address indexed user);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Access denied. Only the Guardian can alter asset metrics.");
        _;
    }

    modifier onlyIPOwner(uint256 _claimId) {
        require(claims[_claimId].registeredOwner == msg.sender, "Error: Access denied. You are not the registered owner of this asset.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    // Hakbang 1: Pagpapatala ng isang bagong IP asset hash (Code base, master key footprint, etc.)
    function registerAssetClaim(bytes32 _ipHash, string memory _assetName) public returns (uint256) {
        require(!ipExists[_ipHash], "Error: This intellectual property cryptographic hash already exists.");
        require(bytes(_assetName).length > 0, "Error: Asset name cannot be empty.");

        totalClaims++;

        claims[totalClaims] = IPClaim({
            id: totalClaims,
            ipHash: _ipHash,
            assetName: _assetName,
            registeredOwner: msg.sender,
            isVerified: false,
            timestamp: block.timestamp
        });

        ipExists[_ipHash] = true;

        emit IPCreated(totalClaims, _ipHash, msg.sender, _assetName);
        return totalClaims;
    }

    // Hakbang 2: Pag-verify ng Guardian sa legalidad at authenticity ng asset
    function verifyAssetClaim(uint256 _claimId, bool _status) public onlyGuardian {
        require(_claimId > 0 && _claimId <= totalClaims, "Error: Target claim ID context non-existent.");
        claims[_claimId].isVerified = _status;
        emit IPVerified(_claimId, _status);
    }

    // Hakbang 3: Pagpasa ng karapatan o awtorisasyon sa ibang wallet (Open OS licensing model)
    function grantAccess(uint256 _claimId, address _user) public onlyIPOwner(_claimId) {
        bytes32 hash = claims[_claimId].ipHash;
        authorizedUsers[hash][_user] = true;
        emit AccessGranted(hash, _user);
    }

    // Hakbang 4: Pagbawi ng karapatan kung magkaroon ng breach o panggagaya
    function revokeAccess(uint256 _claimId, address _user) public onlyIPOwner(_claimId) {
        bytes32 hash = claims[_claimId].ipHash;
        authorizedUsers[hash][_user] = false;
        emit AccessRevoked(hash, _user);
    }

    // View function para sa pormal na on-chain checking ng access tokens
    function checkAuthorization(bytes32 _ipHash, address _user) public view returns (bool) {
        return authorizedUsers[_ipHash][_user];
    }
}
