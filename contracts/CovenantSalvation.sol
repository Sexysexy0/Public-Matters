// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Salvation
/// @notice Deliverance and redemptive safeguard contract
contract CovenantSalvation {
    address public guardian;
    uint256 public salvationCount;

    struct Salvation {
        uint256 id;
        string covenantName;
        string rescuePrinciple;
        string redemptionPath;
        bool delivered;
    }

    mapping(uint256 => Salvation) public salvations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event SalvationDeclared(uint256 indexed id, string covenantName, string rescuePrinciple);
    event SalvationDelivered(uint256 indexed id, string redemptionPath);

    constructor() {
        guardian = msg.sender;
        salvationCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑declare ng salvation principle
    function declareSalvation(string calldata covenantName, string calldata rescuePrinciple) external onlyGuardian {
        salvationCount++;
        salvations[salvationCount] = Salvation(salvationCount, covenantName, rescuePrinciple, "", false);
        emit SalvationDeclared(salvationCount, covenantName, rescuePrinciple);
    }

    /// @notice Mag‑deliver ng salvation at mag‑assign ng redemption path
    function deliverSalvation(uint256 id, string calldata redemptionPath) external onlyGuardian {
        Salvation storage s = salvations[id];
        require(!s.delivered, "Already delivered");
        s.redemptionPath = redemptionPath;
        s.delivered = true;
        emit SalvationDelivered(id, redemptionPath);
    }

    /// @notice Tingnan ang salvation details
    function viewSalvation(uint256 id) external view returns (Salvation memory) {
        return salvations[id];
    }
}
