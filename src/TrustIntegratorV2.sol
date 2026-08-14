// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIndex} from "./ITrustIndex.sol";
import {IUserTrust} from "./IUserTrust.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";

contract TrustIntegratorV2 {
    using SafeCast for uint256;

    ITrustIndex public trustIndex;
    IUserTrust public userTrust;
    address public steward;

    event TrustActionLogged(address indexed actor, string action, uint256 weight);
    event UserTrustAddressUpdated(address newAddress);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _trustIndex, address _userTrust) {
        steward = msg.sender;
        trustIndex = ITrustIndex(_trustIndex);
        userTrust = IUserTrust(_userTrust);
    }

    function setUserTrust(address _newUserTrust) external onlySteward {
        userTrust = IUserTrust(_newUserTrust);
        emit UserTrustAddressUpdated(_newUserTrust);
    }

    function logPositiveAction(string memory action, uint256 weight) external {
        trustIndex.reportTrustAction(weight);
        if (address(userTrust) != address(0)) {
            userTrust.adjustScore(msg.sender, weight.toInt256(), action);
        }
        emit TrustActionLogged(msg.sender, action, weight);
    }

    function logSetback(string memory action, uint256 weight) external {
        trustIndex.reportTrustSetback(weight);
        if (address(userTrust) != address(0)) {
            userTrust.adjustScore(msg.sender, -(weight.toInt256()), action);
        }
        emit TrustActionLogged(msg.sender, action, weight);
    }
}
