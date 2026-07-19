// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EmergencyFreeze
/// @notice Simple guardian-controlled freeze/unfreeze mechanism for identifiers
contract EmergencyFreeze {
    address public guardian;
    mapping(bytes32 => bool) public frozen;

    // ✅ renamed "at" → "timestamp" to avoid reserved keyword warning
    event Frozen(bytes32 indexed id, address by, uint256 timestamp);
    event Unfrozen(bytes32 indexed id, address by, uint256 timestamp);

    constructor(address _guardian) {
        guardian = _guardian;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "only guardian");
        _;
    }

    function freeze(bytes32 id) external onlyGuardian {
        frozen[id] = true;
        emit Frozen(id, msg.sender, block.timestamp);
    }

    function unfreeze(bytes32 id) external onlyGuardian {
        frozen[id] = false;
        emit Unfrozen(id, msg.sender, block.timestamp);
    }
}
