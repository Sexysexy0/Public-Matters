// SPDX-License-Identifier: GlobalLiquidityContinuity-License
pragma solidity ^0.8.0;

contract GlobalLiquidityContinuityRouter {
    address public steward;

    struct ContinuitySignal {
        string FXPair;
        string reroutedPath;
        bool continuityConfirmed;
        string APRStatus;
        uint256 timestamp;
    }

    ContinuitySignal[] public signals;

    event LiquidityContinuityRouted(string FXPair, string reroutedPath, bool continuityConfirmed, string APRStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeContinuity(string memory FXPair, string memory reroutedPath, bool continuityConfirmed, string memory APRStatus) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ContinuitySignal(FXPair, reroutedPath, continuityConfirmed, APRStatus, block.timestamp));
        emit LiquidityContinuityRouted(FXPair, reroutedPath, continuityConfirmed, APRStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ContinuitySignal memory s = signals[index];
        return (s.FXPair, s.reroutedPath, s.continuityConfirmed, s.APRStatus, s.timestamp);
    }
}
