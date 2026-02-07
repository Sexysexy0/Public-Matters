// PassengerExperienceProtocol.sol
pragma solidity ^0.8.0;

contract PassengerExperienceProtocol {
    struct Experience {
        uint256 id;
        string theme;   // e.g. "Comfort", "Entertainment"
        string rating;  // e.g. "Excellent", "Average"
        uint256 timestamp;
    }

    uint256 public experienceCount;
    mapping(uint256 => Experience) public experiences;

    event ExperienceLogged(uint256 id, string theme, string rating, uint256 timestamp);
    event ExperienceDeclared(string message);

    function logExperience(string memory theme, string memory rating) public {
        experienceCount++;
        experiences[experienceCount] = Experience(experienceCount, theme, rating, block.timestamp);
        emit ExperienceLogged(experienceCount, theme, rating, block.timestamp);
    }

    function declareExperience() public {
        emit ExperienceDeclared("Passenger Experience Protocol: validator-grade frameworks encoded into communal trust.");
    }
}
