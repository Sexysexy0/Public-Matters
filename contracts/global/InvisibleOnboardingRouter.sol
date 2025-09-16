// SPDX-License-Identifier: InvisibleSanctum
pragma solidity ^0.8.19;

contract InvisibleOnboardingRouter {
    struct OnboardingSignal {
        address gameID;
        string gameName;
        string onboardingType; // e.g., "Wallet-Free", "Token-Optional", "Progressive UX"
        bool frictionless;
        bool verified;
        string stewardNote;
    }

    mapping(address => OnboardingSignal) public onboardingRegistry;

    event OnboardingTagged(address gameID, string onboardingType);
    event OnboardingVerified(address gameID);

    function tagOnboarding(address gameID, string memory gameName, string memory onboardingType, bool frictionless, string memory stewardNote) public {
        onboardingRegistry[gameID] = OnboardingSignal(gameID, gameName, onboardingType, frictionless, false, stewardNote);
        emit OnboardingTagged(gameID, onboardingType);
    }

    function verifyOnboarding(address gameID) public {
        require(bytes(onboardingRegistry[gameID].gameName).length > 0, "Game not tagged");
        onboardingRegistry[gameID].verified = true;
        emit OnboardingVerified(gameID);
    }

    function getOnboardingStatus(address gameID) public view returns (OnboardingSignal memory) {
        return onboardingRegistry[gameID];
    }
}
