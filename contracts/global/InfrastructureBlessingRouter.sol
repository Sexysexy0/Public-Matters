// SPDX-License-Identifier: InfrastructureBlessing-License
pragma solidity ^0.8.0;

contract InfrastructureBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string projectID;
        string builderID;
        bool treatyAligned;
        string blessingScore;
        bool continuityConfirmed;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event InfrastructureBlessingRouted(string projectID, string builderID, bool treatyAligned, string blessingScore, bool continuityConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory projectID, string memory builderID, bool treatyAligned, string memory blessingScore, bool continuityConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(projectID, builderID, treatyAligned, blessingScore, continuityConfirmed, block.timestamp));
        emit InfrastructureBlessingRouted(projectID, builderID, treatyAligned, blessingScore, continuityConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.projectID, s.builderID, s.treatyAligned, s.blessingScore, s.continuityConfirmed, s.timestamp);
    }
}
