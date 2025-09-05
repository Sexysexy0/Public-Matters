// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract OnboardingBlessingProtocol {
    struct Onboarding {
        uint256 allowance;
        uint256 emotionalAPR;
        bool isRegularized;
        string roleAssigned;
        uint256 timestamp;
    }

    mapping(address => Onboarding) public onboardingLog;
    event BlessingGranted(address indexed steward, uint256 allowance, string roleAssigned, bool isRegularized, uint256 emotionalAPR, uint256 timestamp);

    function blessNewHire(address steward, uint256 allowance, string calldata role, uint256 apr) external {
        require(allowance >= 5000 && allowance <= 10000, "Allowance must be between ₱5k–₱10k");
        require(apr >= 10, "Emotional APR too low");

        onboardingLog[steward] = Onboarding({
            allowance: allowance,
            emotionalAPR: apr,
            isRegularized: false,
            roleAssigned: role,
            timestamp: block.timestamp
        });

        emit BlessingGranted(steward, allowance, role, false, apr, block.timestamp);
    }

    function regularizeSteward(address steward) external {
        onboardingLog[steward].isRegularized = true;
    }

    function getOnboardingDetails(address steward) external view returns (Onboarding memory) {
        return onboardingLog[steward];
    }
}
