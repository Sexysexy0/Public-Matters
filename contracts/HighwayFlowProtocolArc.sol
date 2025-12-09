// contracts/HighwayFlowProtocolArc.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HighwayFlowProtocolArc
 * @notice Quartet seals to improve congested highways:
 * 1. Enforcer Seal → deploy traffic enforcers at choke points.
 * 2. Signal Seal → adaptive traffic lights and lane discipline.
 * 3. Reroute Seal → alternative feeder roads and park-and-ride hubs.
 * 4. Transit Seal → mass transit expansion and active transport lanes.
 *
 * This contract logs initiatives, assigns guardians, and tracks execution status for civic deployments.
 */
contract HighwayFlowProtocolArc {
    // Batch metadata
    string public constant batch = "1321.9.261";
    string public constant arc = "Highway Flow Protocol Arc";

    // Ownership + guardians for controlled writes
    address public owner;
    mapping(address => bool) public guardians;

    // Initiative model
    enum SealType {
        Enforcer,   // 0
        Signal,     // 1
        Reroute,    // 2
        Transit     // 3
    }

    enum Status {
        Planned,    // initiative planned
        Active,     // currently implemented
        Paused,     // temporarily halted
        Completed   // finished
    }

    struct Initiative {
        SealType seal;
        string location;        // e.g., "Marcos Highway - Santolan Interchange"
        string description;     // concise action details
        Status status;
        uint256 timestamp;      // last update or creation time
        address author;         // who logged/updated
    }

    Initiative[] public initiatives;

    event GuardianSet(address indexed account, bool status);
    event InitiativeLogged(uint256 indexed id, SealType seal, string location, Status status);
    event InitiativeUpdated(uint256 indexed id, Status status, string note);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyGuardian() {
        require(guardians[msg.sender], "Not guardian");
        _;
    }

    constructor() {
        owner = msg.sender;
        guardians[msg.sender] = true;
        emit GuardianSet(msg.sender, true);

        // Preload four canonical seals as examples (locations optional)
        _logInitiative(SealType.Enforcer, "Marcos Highway – Choke Points", "Deploy disciplined enforcers and clear illegal stops", Status.Planned);
        _logInitiative(SealType.Signal, "Key Intersections", "Adaptive signal timing + clear lane discipline", Status.Planned);
        _logInitiative(SealType.Reroute, "Feeder Roads & Hubs", "Open alternatives + park-and-ride hubs", Status.Planned);
        _logInitiative(SealType.Transit, "Metro Network", "Accelerate BRT/MRT + bike/ped lanes", Status.Planned);
    }

    // Owner can appoint or remove guardians (LGU/agency coordinators)
    function setGuardian(address account, bool status) external onlyOwner {
        guardians[account] = status;
        emit GuardianSet(account, status);
    }

    // Log new initiative under a seal
    function logInitiative(
        SealType seal,
        string calldata location,
        string calldata description,
        Status status
    ) external onlyGuardian returns (uint256 id) {
        id = _logInitiative(seal, location, description, status);
    }

    // Update status with optional note via event
    function updateInitiativeStatus(uint256 id, Status status, string calldata note) external onlyGuardian {
        require(id < initiatives.length, "Invalid initiative id");
        initiatives[id].status = status;
        initiatives[id].timestamp = block.timestamp;
        initiatives[id].author = msg.sender;
        emit InitiativeUpdated(id, status, note);
    }

    // View helpers
    function totalInitiatives() external view returns (uint256) {
        return initiatives.length;
    }

    function getInitiative(uint256 id) external view returns (Initiative memory) {
        require(id < initiatives.length, "Invalid initiative id");
        return initiatives[id];
    }

    // Internal logger
    function _logInitiative(
        SealType seal,
        string memory location,
        string memory description,
        Status status
    ) internal returns (uint256 id) {
        initiatives.push(
            Initiative({
                seal: seal,
                location: location,
                description: description,
                status: status,
                timestamp: block.timestamp,
                author: msg.sender
            })
        );
        id = initiatives.length - 1;
        emit InitiativeLogged(id, seal, location, status);
    }
}
