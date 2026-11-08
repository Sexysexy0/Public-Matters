// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title EnvironmentalBondEscrow
 * @notice Holds the financial bond of extractive companies. 
 *         If a disaster occurs, funds are forfeited to the victims.
 */
contract EnvironmentalBondEscrow {
    OperatorPrivileges public immutable privileges;
    address public immutable communityFund;

    mapping(bytes32 => uint256) public bondAmounts; // permitId => ETH amount

    event BondDeposited(bytes32 indexed permitId, address indexed company, uint256 amount);
    event BondReleased(bytes32 indexed permitId, address indexed company, uint256 amount);
    event BondForfeited(bytes32 indexed permitId, address indexed disasterFund, uint256 amount);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges, address _communityFund) {
        require(_privileges != address(0), "privileges=0");
        require(_communityFund != address(0), "fund=0");
        privileges = OperatorPrivileges(_privileges);
        communityFund = _communityFund;
    }

    function depositBond(bytes32 permitId) external payable {
        require(msg.value > 0, "Bond must be > 0");
        bondAmounts[permitId] += msg.value;
        emit BondDeposited(permitId, msg.sender, msg.value);
    }

    /**
     * @notice Called if mining is clean and no disaster occurs.
     */
    function releaseBond(bytes32 permitId, address payable company) external onlyOperator {
        uint256 amount = bondAmounts[permitId];
        require(amount > 0, "No bond");
        
        bondAmounts[permitId] = 0; // CEI pattern
        (bool success, ) = company.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit BondReleased(permitId, company, amount);
    }

    /**
     * @notice Called if the mountain collapses or a disaster is proven.
     *         Money goes straight to the community, bypassing the government.
     */
    function forfeitBond(bytes32 permitId) external onlyOperator {
        uint256 amount = bondAmounts[permitId];
        require(amount > 0, "No bond");
        
        bondAmounts[permitId] = 0; // CEI pattern
        
        (bool success, ) = payable(communityFund).call{value: amount}("");
        require(success, "Forfeit failed");
        
        emit BondForfeited(permitId, communityFund, amount);
    }
}
