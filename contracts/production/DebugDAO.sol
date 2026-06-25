// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DebugDAO
/// @notice Secure bug tracking DAO with access control
/// @dev Prevents unauthorized bug status changes and tracks all modifications
contract DebugDAO {
    address public admin;
    address public pendingAdmin;

    struct Bug {
        uint256 id;
        string module;
        string detail;
        bool fixed;
        uint256 timestamp;
    }

    uint256 public bugCount;
    mapping(uint256 => Bug) public bugs;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event BugLogged(uint256 indexed id, string module, string detail, uint256 timestamp);
    event BugFixed(uint256 indexed id, string module, address indexed fixer);
    event AdminTransferInitiated(address indexed newAdmin);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    modifier onlyAdmin() {
        require(msg.sender == admin, "DebugDAO: Only admin can call this");
        _;
    }

    modifier validInput(string memory _str) {
        require(bytes(_str).length > 0, "DebugDAO: Input cannot be empty");
        require(bytes(_str).length <= 256, "DebugDAO: Input too long");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /// @notice Log a new bug
    /// @param module The affected module
    /// @param detail Bug details
    function logBug(string memory module, string memory detail)
        external
        validInput(module)
        validInput(detail)
    {
        bugCount++;
        bugs[bugCount] = Bug(bugCount, module, detail, false, block.timestamp);
        emit BugLogged(bugCount, module, detail, block.timestamp);
    }

    /// @notice Mark a bug as fixed (admin only)
    /// @param id Bug ID to fix
    function fixBug(uint256 id) external onlyAdmin {
        require(id > 0 && id <= bugCount, "DebugDAO: Invalid bug ID");
        require(!bugs[id].fixed, "DebugDAO: Bug already fixed");
        
        bugs[id].fixed = true;
        emit BugFixed(id, bugs[id].module, msg.sender);
    }

    /// @notice Initiate admin transfer
    /// @param newAdmin Address of new admin
    function initiateAdminTransfer(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "DebugDAO: Invalid admin address");
        pendingAdmin = newAdmin;
        emit AdminTransferInitiated(newAdmin);
    }

    /// @notice Accept admin transfer
    function acceptAdminTransfer() external {
        require(msg.sender == pendingAdmin, "DebugDAO: Only pending admin can accept");
        address oldAdmin = admin;
        admin = pendingAdmin;
        pendingAdmin = address(0);
        emit AdminTransferred(oldAdmin, admin);
    }

    /// @notice Get bug details
    /// @param id Bug ID
    function getBug(uint256 id) external view returns (Bug memory) {
        require(id > 0 && id <= bugCount, "DebugDAO: Invalid bug ID");
        return bugs[id];
    }
}
