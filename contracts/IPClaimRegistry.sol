// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IPClaimRegistry {
    address public guardian;
    uint256 public totalClaims;

    struct AssetClaim {
        uint256 id;
        bytes32 ipHash;
        // SLOT HYDRATION: Naka-pack sa iisang 32-byte slot (20 + 1 + 1 bytes = 22 bytes)
        address owner;
        bool isVerified;
        bool isActive;
        // --- End of Slot ---
        string assetMetadata;
    }

    mapping(uint256 => AssetClaim) public claims;
    mapping(bytes32 => address) public ipToOwner;
    mapping(bytes32 => mapping(address => bool)) public authorizations;

    event AssetClaimRegistered(uint256 indexed claimId, bytes32 indexed ipHash, address indexed owner);
    event AssetClaimVerified(uint256 indexed claimId, bool indexed status);
    event AccessGranted(bytes32 indexed ipHash, address indexed user);
    event AccessRevoked(bytes32 indexed ipHash, address indexed user);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Access denied. Only the Guardian can alter asset metrics.");
        _;
    }

    modifier onlyAssetOwner(uint256 _claimId) {
        require(claims[_claimId].owner == msg.sender, "Error: Access denied. You are not the registered owner of this asset.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    function registerAssetClaim(bytes32 _ipHash, string memory _metadata) public returns (uint256) {
        require(ipToOwner[_ipHash] == address(0), "Error: This asset hash has already been registered.");

        totalClaims++;
        claims[totalClaims] = AssetClaim({
            id: totalClaims,
            ipHash: _ipHash,
            owner: msg.sender,
            isVerified: false,
            isActive: true,
            assetMetadata: _metadata
        });

        ipToOwner[_ipHash] = msg.sender;
        authorizations[_ipHash][msg.sender] = true;

        emit AssetClaimRegistered(totalClaims, _ipHash, msg.sender);
        return totalClaims;
    }

    function verifyAssetClaim(uint256 _claimId, bool _status) public onlyGuardian {
        require(_claimId > 0 && _claimId <= totalClaims, "Error: Non-existent claim context.");
        claims[_claimId].isVerified = _status;
        emit AssetClaimVerified(_claimId, _status);
    }

    function grantAccess(uint256 _claimId, address _user) public onlyAssetOwner(_claimId) {
        bytes32 targetHash = claims[_claimId].ipHash;
        authorizations[targetHash][_user] = true;
        emit AccessGranted(targetHash, _user);
    }

    function revokeAccess(uint256 _claimId, address _user) public onlyAssetOwner(_claimId) {
        bytes32 targetHash = claims[_claimId].ipHash;
        authorizations[targetHash][_user] = false;
        emit AccessRevoked(targetHash, _user);
    }

    function checkAuthorization(bytes32 _ipHash, address _user) public view returns (bool) {
        return authorizations[_ipHash][_user];
    }
}
