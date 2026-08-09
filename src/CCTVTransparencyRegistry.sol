// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CCTVTransparencyRegistry
 * @dev Decentralized registry for public CCTV cameras.
 * Forces transparency and accountability on mass surveillance.
 */
contract CCTVTransparencyRegistry {
    address public immutable owner;

    struct Camera {
        address owner; // Govt agency or private entity managing the camera
        string location; // Barangay / Street / Area
        bytes32 publicKeyHash; // Hash ng public key para sa footage verification
        bool isActive;
        uint256 dateRegistered;
    }

    struct FootageLog {
        uint256 cameraId;
        bytes32 footageHash; // SHA-256 hash ng daily footage summary
        uint256 timestamp;
        uint256 dayIndex; // 0 = Day 1, 1 = Day 2, etc.
    }

    struct AccessRequest {
        address requester; // Pulis, investigator, or citizen
        uint256 cameraId;
        uint256 dayIndex; // Which day's footage they want
        string purpose; // Reason for access
        uint256 requestTime;
        bool approved;
        bool footageReleased;
    }

    mapping(uint256 => Camera) public cameras;
    mapping(uint256 => FootageLog[]) public footageLogs; // cameraId => array of daily logs
    mapping(uint256 => AccessRequest[]) public accessLogs; // cameraId => array of access requests

    uint256 public cameraCount;
    uint256 public totalAccessRequests;

    event CameraRegistered(uint256 indexed id, address owner, string location);
    event FootageLogged(uint256 indexed cameraId, uint256 dayIndex, bytes32 footageHash);
    event AccessRequested(uint256 indexed cameraId, address requester, string purpose);
    event AccessApproved(uint256 indexed cameraId, uint256 requestIndex, address approver);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the Ghost Architect");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Govt/Admin registers a CCTV camera
    function registerCamera(string memory _location, bytes32 _publicKeyHash) external onlyOwner returns (uint256) {
        cameraCount++;
        cameras[cameraCount] = Camera({
            owner: msg.sender,
            location: _location,
            publicKeyHash: _publicKeyHash,
            isActive: true,
            dateRegistered: block.timestamp
        });
        emit CameraRegistered(cameraCount, msg.sender, _location);
        return cameraCount;
    }

    // Daily operation: agencies log the hash of the footage for that day
    function logDailyFootage(uint256 _cameraId, bytes32 _footageHash) external {
        require(cameras[_cameraId].isActive, "Camera inactive");
        // Ensure only the camera owner or authorized operator logs this
        // For now, let's keep it open so citizens can submit hashes too (making it decentralized)
        // But we'll add an optional "reporter" field. Let's keep it simple and allow anyone to log it.
        uint256 dayIndex = footageLogs[_cameraId].length;
        footageLogs[_cameraId].push(
            FootageLog({cameraId: _cameraId, footageHash: _footageHash, timestamp: block.timestamp, dayIndex: dayIndex})
        );
        emit FootageLogged(_cameraId, dayIndex, _footageHash);
    }

    // A law enforcement officer requests access to a specific day's footage
    function requestFootageAccess(uint256 _cameraId, uint256 _dayIndex, string memory _purpose) external {
        require(cameras[_cameraId].isActive, "Camera inactive");
        require(_dayIndex < footageLogs[_cameraId].length, "Day index out of range");

        AccessRequest memory newRequest = AccessRequest({
            requester: msg.sender,
            cameraId: _cameraId,
            dayIndex: _dayIndex,
            purpose: _purpose,
            requestTime: block.timestamp,
            approved: false,
            footageReleased: false
        });

        accessLogs[_cameraId].push(newRequest);
        totalAccessRequests++;
        emit AccessRequested(_cameraId, msg.sender, _purpose);
    }

    // The Ghost Architect (or a citizen oversight DAO) approves the request
    function approveAccess(uint256 _cameraId, uint256 _requestIndex) external onlyOwner {
        AccessRequest storage request = accessLogs[_cameraId][_requestIndex];
        require(!request.approved, "Already approved");
        require(!request.footageReleased, "Already released");

        request.approved = true;
        emit AccessApproved(_cameraId, _requestIndex, msg.sender);
    }

    // Mark that the requester has received the decryption keys (off-chain)
    function markFootageReleased(uint256 _cameraId, uint256 _requestIndex) external onlyOwner {
        AccessRequest storage request = accessLogs[_cameraId][_requestIndex];
        require(request.approved, "Not approved yet");
        require(!request.footageReleased, "Already released");

        request.footageReleased = true;
    }

    // Get camera info
    function getCameraInfo(uint256 _id) external view returns (Camera memory) {
        return cameras[_id];
    }

    // Get footage hash for a specific day
    function getFootageHash(uint256 _cameraId, uint256 _dayIndex) external view returns (bytes32) {
        require(_dayIndex < footageLogs[_cameraId].length, "Index out of bounds");
        return footageLogs[_cameraId][_dayIndex].footageHash;
    }
}
