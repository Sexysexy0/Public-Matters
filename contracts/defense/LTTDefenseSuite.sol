// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VendorShutdownProtection
 * @notice Protects consumers from arbitrary server shutdowns by enforcing automated key releases.
 */
contract VendorShutdownProtection {
    struct SystemStatus {
        bool isServerAlive;
        uint256 lastHeartbeat;
        string offlinePatchHash;
    }

    address public vendor;
    SystemStatus public status;
    uint256 public constant HEARTBEAT_TIMEOUT = 90 days;

    event HeartbeatReceived(uint256 timestamp);
    event VendorAbandoned(string offlinePatchHash);

    modifier onlyVendor() {
        require(msg.sender == vendor, "Unauthorized vendor");
        _;
    }

    constructor(string memory initialPatchHash) {
        vendor = msg.sender;
        status = SystemStatus({
            isServerAlive: true,
            lastHeartbeat: block.timestamp,
            offlinePatchHash: initialPatchHash
        });
    }

    function pingHeartbeat() external onlyVendor {
        require(status.isServerAlive, "System already declared abandoned");
        status.lastHeartbeat = block.timestamp;
        emit HeartbeatReceived(block.timestamp);
    }

    function triggerAbandonmentRelease() external {
        require(
            block.timestamp > status.lastHeartbeat + HEARTBEAT_TIMEOUT,
            "Vendor still active within SLA window"
        );
        status.isServerAlive = false;
        emit VendorAbandoned(status.offlinePatchHash);
    }
}

/**
 * @title DigitalOwnershipEnforcer
 * @notice Irrevocable digital license registry ensuring true consumer ownership.
 */
contract DigitalOwnershipEnforcer {
    mapping(uint256 => address) public licenseOwner;
    mapping(uint256 => bool) public isTransferRestricted;

    event LicenseIssued(uint256 indexed licenseId, address indexed owner);
    event LicenseTransferred(uint256 indexed licenseId, address indexed from, address indexed to);

    function issueLicense(uint256 licenseId, address owner) external {
        require(licenseOwner[licenseId] == address(0), "License ID already exists");
        licenseOwner[licenseId] = owner;
        emit LicenseIssued(licenseId, owner);
    }

    function transferLicense(uint256 licenseId, address newOwner) external {
        require(licenseOwner[licenseId] == msg.sender, "Not the license owner");
        require(!isTransferRestricted[licenseId], "License transfer locked by governance");
        
        licenseOwner[licenseId] = newOwner;
        emit LicenseTransferred(licenseId, msg.sender, newOwner);
    }
}
