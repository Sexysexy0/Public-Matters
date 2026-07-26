// CircadianExperienceDAO.sol
pragma solidity ^0.8.0;

contract CircadianExperienceDAO {
    function getNightBias(uint256 _hour) public pure returns (string memory) {
        if (_hour >= 22 || _hour <= 4) {
            // High probability of 'Maulan at Malamig' logic
            return "SLEEP_OPTIMIZED_WEATHER";
        }
        return "STANDARD_RANDOM";
    }
}
