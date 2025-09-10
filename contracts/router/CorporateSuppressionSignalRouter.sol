// SPDX-License-Identifier: CorporateSuppressionSignal-License
pragma solidity ^0.8.0;

contract CorporateSuppressionSignalRouter {
    address public steward;

    struct SuppressionSignal {
        string creatorID;
        string contentID;
        string threatType;
        string corporateEntity;
        bool restorationActivated;
        uint256 timestamp;
    }

    SuppressionSignal[] public signals;

    event SuppressionSignalRouted(string creatorID, string contentID, string threatType, string corporateEntity, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory creatorID, string memory contentID, string memory threatType, string memory corporateEntity, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(SuppressionSignal(creatorID, contentID, threatType, corporateEntity, restorationActivated, block.timestamp));
        emit SuppressionSignalRouted(creatorID, contentID, threatType, corporateEntity, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        SuppressionSignal memory s = signals[index];
        return (s.creatorID, s.contentID, s.threatType, s.corporateEntity, s.restorationActivated, s.timestamp);
    }
}
