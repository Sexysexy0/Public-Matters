// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract PermissionlessBroadcast {
    ITrustIntegrator public trustIntegrator;
    address public steward;

    struct Broadcast {
        address broadcaster;
        string content;
        uint256 timestamp;
    }

    Broadcast[] public broadcasts;

    event BroadcastSent(address indexed broadcaster, string content, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _trustIntegrator) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function broadcast(string calldata content) external {
        broadcasts.push(Broadcast(msg.sender, content, block.timestamp));
        trustIntegrator.logPositiveAction(string(abi.encodePacked("Broadcast: ", content)), 10);
        emit BroadcastSent(msg.sender, content, block.timestamp);
    }

    function getBroadcastCount() external view returns (uint256) {
        return broadcasts.length;
    }

    function getBroadcast(uint256 index) external view returns (address, string memory, uint256) {
        require(index < broadcasts.length, "Index out of bounds");
        Broadcast memory b = broadcasts[index];
        return (b.broadcaster, b.content, b.timestamp);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}
