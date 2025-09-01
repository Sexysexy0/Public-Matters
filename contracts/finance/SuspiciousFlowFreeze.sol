// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract SuspiciousFlowFreeze {
    mapping(address => bool) public frozenAccounts;
    mapping(address => uint256) public flaggedAmount;
    event AccountFrozen(address indexed steward, uint256 amount, string reason);
    event AccountUnfrozen(address indexed steward);

    modifier onlyTrustedSanctum() {
        require(msg.sender == sanctumValidator, "Untrusted origin");
        _;
    }

    address public sanctumValidator;

    constructor(address _validator) {
        sanctumValidator = _validator;
    }

    function freezeAccount(address steward, uint256 amount, string memory reason) external onlyTrustedSanctum {
        frozenAccounts[steward] = true;
        flaggedAmount[steward] = amount;
        emit AccountFrozen(steward, amount, reason);
    }

    function unfreezeAccount(address steward) external onlyTrustedSanctum {
        frozenAccounts[steward] = false;
        flaggedAmount[steward] = 0;
        emit AccountUnfrozen(steward);
    }

    function isFrozen(address steward) external view returns (bool) {
        return frozenAccounts[steward];
    }
}
