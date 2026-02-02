// AdoptionCatalystProtocol.sol
pragma solidity ^0.8.0;

contract AdoptionCatalystProtocol {
    struct Onboarding {
        uint256 id;
        address user;
        string method;   // e.g. "Tutorial", "Workshop", "Wallet Setup"
        uint256 timestamp;
    }

    uint256 public onboardingCount;
    mapping(uint256 => Onboarding) public onboardings;

    event UserOnboarded(uint256 id, address user, string method, uint256 timestamp);
    event AdoptionDeclared(string message);

    function onboardUser(address user, string memory method) public {
        onboardingCount++;
        onboardings[onboardingCount] = Onboarding(onboardingCount, user, method, block.timestamp);
        emit UserOnboarded(onboardingCount, user, method, block.timestamp);
    }

    function declareAdoption() public {
        emit AdoptionDeclared("Adoption Catalyst Protocol: education and onboarding arcs expanding crypto communities.");
    }
}
