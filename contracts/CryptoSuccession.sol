// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CryptoSuccession
/// @notice Governance contract encoding leadership transition at Crypto AG
/// @dev Ensures transparent handover from Hagelin Senior to Hagelin Junior

contract CryptoSuccession {
    address public founder;
    address public successor;
    bool public transitionComplete;

    event SuccessorAppointed(address indexed successor, uint256 timestamp);
    event TransitionExecuted(address indexed founder, address indexed successor, uint256 timestamp);

    modifier onlyFounder() {
        require(msg.sender == founder, "Not authorized");
        _;
    }

    constructor(address _founder) {
        founder = _founder;
        transitionComplete = false;
    }

    /// @notice Appoint a successor (e.g., Hagelin Jr.)
    /// @param _successor address of the successor
    function appointSuccessor(address _successor) external onlyFounder {
        successor = _successor;
        emit SuccessorAppointed(_successor, block.timestamp);
    }

    /// @notice Execute the leadership transition
    function executeTransition() external onlyFounder {
        require(successor != address(0), "No successor appointed");
        require(!transitionComplete, "Already transitioned");
        transitionComplete = true;
        emit TransitionExecuted(founder, successor, block.timestamp);
    }

    /// @notice Verify if transition is complete
    /// @return true if leadership has been handed over
    function isTransitionComplete() external view returns (bool) {
        return transitionComplete;
    }
}
