// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrow
 * @notice Automatically escrows company penalty funds
 *         and reroutes them to community utilities (electric bills)
 *         whenever a violation is logged.
 */
contract AutoPenaltyEscrow {
    address public steward;
    address public utilityTreasury; // barangay/community electric fund

    struct Company {
        string name;
        address operator;
        bool registered;
        uint256 escrowBalance;
    }

    mapping(address => Company) public companies;
    mapping(address => bool) public regulators;

    event CompanyRegistered(address indexed id, address indexed operator, string name);
    event PenaltyDeposited(address indexed operator, uint256 amount, string reason);
    event CommunityPaid(uint256 amount, string purpose);

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyRegulator() {
        require(regulators[msg.sender], "Not regulator");
        _;
    }

    constructor(address _utilityTreasury) {
        steward = msg.sender;
        utilityTreasury = _utilityTreasury;
        regulators[msg.sender] = true;
    }

    function setRegulator(address reg, bool status) external onlySteward {
        regulators[reg] = status;
    }

    function registerCompany(address id, address op, string calldata name) external onlySteward {
        companies[id] = Company(name, op, true, 0);
        emit CompanyRegistered(id, op, name);
    }

    function logPenalty(address id, string calldata reason) external payable onlyRegulator {
        Company storage c = companies[id];
        require(c.registered, "Not registered");
        require(msg.value > 0, "No penalty amount");
        c.escrowBalance += msg.value;
        emit PenaltyDeposited(c.operator, msg.value, reason);
        _autoPayCommunity(id);
    }

    function _autoPayCommunity(address id) internal {
        Company storage c = companies[id];
        uint256 payout = c.escrowBalance;
        c.escrowBalance = 0;
        (bool sent, ) = payable(utilityTreasury).call{value: payout}("");
        require(sent, "Failed to send to community");
        emit CommunityPaid(payout, "Electric utility coverage");
    }
}
