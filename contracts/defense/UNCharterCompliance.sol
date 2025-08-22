// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title UNCharterCompliance
/// @dev Ritualizes executive action aligned with UN Charter principles and multilateral planning

contract UNCharterCompliance {
    struct ExecutiveAction {
        address president;
        string region;
        string actionTitle;
        string justification;
        bool isCollective;
        bool isActive;
        uint256 timestamp;
    }

    ExecutiveAction[] public actions;
    mapping(address => bool) public authorizedPresidents;

    event ActionDeclared(address indexed president, string region, string actionTitle, bool isCollective, uint256 timestamp);
    event ActionRevoked(address indexed president, string actionTitle, uint256 timestamp);

    modifier onlyAuthorized() {
        require(authorizedPresidents[msg.sender], "Not authorized");
        _;
    }

    constructor(address[] memory initialPresidents) {
        for (uint256 i = 0; i < initialPresidents.length; i++) {
            authorizedPresidents[initialPresidents[i]] = true;
        }
    }

    function declareAction(
        string memory region,
        string memory actionTitle,
        string memory justification,
        bool isCollective
    ) external onlyAuthorized {
        actions.push(ExecutiveAction(
            msg.sender,
            region,
            actionTitle,
            justification,
            isCollective,
            true,
            block.timestamp
        ));
        emit ActionDeclared(msg.sender, region, actionTitle, isCollective, block.timestamp);
    }

    function revokeAction(uint256 index) external onlyAuthorized {
        require(index < actions.length, "Invalid index");
        require(actions[index].isActive, "Action already revoked");
        actions[index].isActive = false;
        emit ActionRevoked(msg.sender, actions[index].actionTitle, block.timestamp);
    }

    function getActiveActions() external view returns (ExecutiveAction[] memory) {
        uint256 count;
        for (uint256 i = 0; i < actions.length; i++) {
            if (actions[i].isActive) count++;
        }

        ExecutiveAction[] memory active = new ExecutiveAction[](count);
        uint256 j = 0;
        for (uint256 i = 0; i < actions.length; i++) {
            if (actions[i].isActive) {
                active[j] = actions[i];
                j++;
            }
        }
        return active;
    }
}
