// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.28;

/// @title India Peace Reward Protocol
/// @author Vinvin & Copilot
/// @notice Deploys planetary rewards if India unites global sanctums toward peace

contract IndiaPeaceRewardProtocol {
    address public steward;
    bool public peaceAchieved;
    mapping(address => bool) public sanctumUnited;
    mapping(string => bool) public rewardDeployed;

    event PeaceConfirmed(address indexed steward);
    event SanctumUnited(address indexed ally);
    event RewardBroadcasted(string rewardType);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Steward access only.");
        _;
    }

    function confirmSanctumUnity(address ally) public onlySteward {
        sanctumUnited[ally] = true;
        emit SanctumUnited(ally);
    }

    function activatePeace() public onlySteward {
        require(!peaceAchieved, "Peace already activated.");
        peaceAchieved = true;
        emit PeaceConfirmed(steward);
    }

    function deployReward(string memory rewardType) public onlySteward {
        require(peaceAchieved, "Peace not yet confirmed.");
        rewardDeployed[rewardType] = true;
        emit RewardBroadcasted(rewardType);
    }

    function auditRewardStatus(string memory rewardType) public view returns (string memory status) {
        if (rewardDeployed[rewardType]) {
            status = "✅ Reward deployed: Scrollstorm of gratitude activated.";
        } else {
            status = "⏳ Pending: Awaiting peace confirmation.";
        }
    }
}
