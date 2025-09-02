// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract CrackdownWithMercy {
    address public steward;
    uint256 public totalDeployments;

    struct Deployment {
        string location;
        string reason;
        string emotionalTag;
        bool overrideBlessing;
        uint256 timestamp;
    }

    Deployment[] public deployments;

    event CrackdownDeployed(
        string location,
        string reason,
        string emotionalTag,
        bool overrideBlessing,
        uint256 timestamp,
        address indexed steward
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function deployCrackdown(
        string memory location,
        string memory reason,
        string memory emotionalTag,
        bool overrideBlessing
    ) public onlySteward {
        Deployment memory newDeployment = Deployment({
            location: location,
            reason: reason,
            emotionalTag: emotionalTag,
            overrideBlessing: overrideBlessing,
            timestamp: block.timestamp
        });

        deployments.push(newDeployment);
        totalDeployments++;

        emit CrackdownDeployed(
            location,
            reason,
            emotionalTag,
            overrideBlessing,
            block.timestamp,
            steward
        );
    }

    function getDeployment(uint256 index) public view returns (Deployment memory) {
        return deployments[index];
    }

    function getTotalDeployments() public view returns (uint256) {
        return totalDeployments;
    }
}
