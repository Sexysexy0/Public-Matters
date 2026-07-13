// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Alpha
/// @notice Beginning and origin safeguard contract
contract CovenantAlpha {
    address public guardian;
    uint256 public alphaCount;

    struct Origin {
        uint256 id;
        string name;
        string principle;
        bool anchored;
    }

    mapping(uint256 => Origin> public origins;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event AlphaDeclared(uint256 indexed id, string name, string principle);

    constructor() {
        guardian = msg.sender;
        alphaCount = 0;
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

    function declareAlpha(
        string calldata name,
        string calldata principle,
        bool anchored
    ) external onlyGuardian {
        alphaCount++;
        origins[alphaCount] = Origin(alphaCount, name, principle, anchored);
        emit AlphaDeclared(alphaCount, name, principle);
    }

    function viewAlpha(uint256 id) external view returns (Origin memory) {
        return origins[id];
    }
}
