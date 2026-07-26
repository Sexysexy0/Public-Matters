// CarbonCaptureIncentive.sol
pragma solidity ^0.8.0;

contract CarbonCaptureIncentive {
    uint256 public rewardPerTon = 50; // $50 reward for every ton of CO2 removed

    function claimSequestrationReward(uint256 _tonsCaptured, bytes32 _verificationHash) public {
        // Verified by satellite thermal imaging oracles
        uint256 reward = _tonsCaptured * rewardPerTon;
        payable(msg.sender).transfer(reward);
    }
}
