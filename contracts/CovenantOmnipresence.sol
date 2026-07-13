// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Omnipresence
/// @notice Absolute presence and reach safeguard contract
contract CovenantOmnipresence {
    address public guardian;
    uint256 public presenceCount;

    struct Presence {
        uint256 id;
        string realm;
        string mode;
        bool active;
    }

    mapping(uint256 => Presence) public presences;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event PresenceDeclared(uint256 indexed id, string realm, string mode);

    constructor() {
        guardian = msg.sender;
        presenceCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    function declarePresence(
        string calldata realm,
        string calldata mode,
        bool active
    ) external onlyGuardian {
        presenceCount++;
        presences[presenceCount] = Presence(presenceCount, realm, mode, active);
        emit PresenceDeclared(presenceCount, realm, mode);
    }

    function viewPresence(uint256 id) external view returns (Presence memory) {
        return presences[id];
    }
}
