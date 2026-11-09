// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title SanctionsComplianceRegistry
 * @notice Proactive on-chain compliance registry to flag high-risk wallets.
 *         Protects platforms from facilitating illicit flows (e.g., FinCEN actions).
 */
contract SanctionsComplianceRegistry {
    OperatorPrivileges public immutable privileges;

    struct FlaggedAddress {
        bytes32 addressHash;    // keccak256(address) for privacy on-chain
        bytes32 reasonHash;     // e.g., "OFAC-SDN", "FinCEN-2026-MEXC"
        address flaggedBy;      // The operator who flagged it
        uint256 flaggedAt;
        bool isActive;
    }

    mapping(bytes32 => FlaggedAddress) public flaggedAddresses;
    uint256 public totalFlagged;

    event AddressFlagged(bytes32 indexed addressHash, bytes32 reasonHash, address indexed operator);
    event AddressCleared(bytes32 indexed addressHash, address indexed operator);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    /**
     * @notice Flag a wallet address (hashed) for non-compliance or illicit activity.
     * @dev The actual address is hashed to maintain zero-knowledge on public ledger.
     */
    function flagAddress(address target, bytes32 reasonHash) external onlyOperator {
        bytes32 addrHash = keccak256(abi.encodePacked(target));
        require(!flaggedAddresses[addrHash].isActive, "Address already flagged");

        flaggedAddresses[addrHash] = FlaggedAddress({
            addressHash: addrHash,
            reasonHash: reasonHash,
            flaggedBy: msg.sender,
            flaggedAt: block.timestamp,
            isActive: true
        });

        totalFlagged++;
        emit AddressFlagged(addrHash, reasonHash, msg.sender);
    }

    /**
     * @notice Remove a flag if an investigation clears the address.
     */
    function clearAddress(address target) external onlyOperator {
        bytes32 addrHash = keccak256(abi.encodePacked(target));
        require(flaggedAddresses[addrHash].isActive, "Address not flagged");

        flaggedAddresses[addrHash].isActive = false;
        emit AddressCleared(addrHash, msg.sender);
    }

    function isAddressFlagged(address target) external view returns (bool) {
        bytes32 addrHash = keccak256(abi.encodePacked(target));
        return flaggedAddresses[addrHash].isActive;
    }
}
