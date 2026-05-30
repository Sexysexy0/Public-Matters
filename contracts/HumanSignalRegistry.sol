// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HumanSignalRegistry
/// @notice Registry safeguard for timestamping and verifying human-authored content
/// @dev Works with ContentIntegrityOracle + DAO governance

contract HumanSignalRegistry {
    address public registrar;
    mapping(bytes32 => uint256) public signalTimestamp;
    mapping(bytes32 => address) public signalAuthor;
    event HumanSignalRegistered(bytes32 indexed contentHash, address indexed author, uint256 timestamp);
    event HumanSignalRevoked(bytes32 indexed contentHash, uint256 timestamp);

    modifier onlyRegistrar() {
        require(msg.sender == registrar, "Not authorized");
        _;
    }

    constructor(address _registrar) {
        registrar = _registrar;
    }

    /// @notice Register human-authored content
    /// @param contentHash keccak256 hash of the content
    function registerSignal(bytes32 contentHash) external {
        require(signalTimestamp[contentHash] == 0, "Already registered");
        signalTimestamp[contentHash] = block.timestamp;
        signalAuthor[contentHash] = msg.sender;
        emit HumanSignalRegistered(contentHash, msg.sender, block.timestamp);
    }

    /// @notice Revoke a human signal (DAO or registrar decision)
    /// @param contentHash keccak256 hash of the content
    function revokeSignal(bytes32 contentHash) external onlyRegistrar {
        require(signalTimestamp[contentHash] != 0, "Not registered");
        delete signalTimestamp[contentHash];
        delete signalAuthor[contentHash];
        emit HumanSignalRevoked(contentHash, block.timestamp);
    }

    /// @notice Verify if content has a human signal
    /// @param contentHash keccak256 hash of the content
    /// @return author address of human signal
    /// @return timestamp block time of registration
    function verifySignal(bytes32 contentHash) external view returns (address author, uint256 timestamp) {
        return (signalAuthor[contentHash], signalTimestamp[contentHash]);
    }
}
