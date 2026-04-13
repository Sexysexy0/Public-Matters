// SentimentBioFeedbackDAO.sol
pragma solidity ^0.8.0;

contract SentimentBioFeedbackDAO {
    address public admin;

    enum Mood { Exhausted, Anxious, Content, Joyful, Melancholic }

    struct SentimentData {
        Mood collectiveMood;
        uint256 stressIndex;      // 0 to 100
        uint256 vitalityLevel;    // Energy of the world
        uint256 timestamp;
    }

    SentimentData public currentWorldSentiment;

    event MoodUpdated(Mood newMood, uint256 stressIndex);

    constructor() {
        admin = msg.sender;
    }

    // Kinukuha ang data mula sa Neural Oracles at Bio-sensors
    function updateGlobalSentiment(
        Mood _mood, 
        uint256 _stress, 
        uint256 _vitality
    ) public {
        require(msg.sender == admin, "Unauthorized: Only the Institution can update mood.");
        
        currentWorldSentiment = SentimentData({
            collectiveMood: _mood,
            stressIndex: _stress,
            vitalityLevel: _vitality,
            timestamp: block.timestamp
        });

        emit MoodUpdated(_mood, _stress);
    }

    // Helper function para sa Weathering Factories
    function getAtmosphericRequirement() public view returns (string memory) {
        if (currentWorldSentiment.stressIndex > 70) {
            return "ACTIVATE_CALM_MIST_AND_SILENCE";
        } 
        if (currentWorldSentiment.collectiveMood == Mood.Exhausted) {
            return "TRIGGER_SOOTHING_RAIN_SLEEP_PROTOCOL";
        }
        return "MAINTAIN_RANDOM_HARMONY";
    }
}
