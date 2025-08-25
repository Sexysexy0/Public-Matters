pragma solidity ^0.8.19;

contract JoyIndexLeaderboard {
    struct BarangayScore {
        string name;
        uint8 joyIndex;
    }

    BarangayScore[] public leaderboard;

    function submitScore(string memory _name, uint8 _joyIndex) public {
        leaderboard.push(BarangayScore(_name, _joyIndex));
    }

    function getTopBarangay() public view returns (string memory, uint8) {
        require(leaderboard.length > 0, "No entries yet");
        uint8 topScore = 0;
        string memory topBarangay = "";

        for (uint256 i = 0; i < leaderboard.length; i++) {
            if (leaderboard[i].joyIndex > topScore) {
                topScore = leaderboard[i].joyIndex;
                topBarangay = leaderboard[i].name;
            }
        }

        return (topBarangay, topScore);
    }

    function totalEntries() public view returns (uint256) {
        return leaderboard.length;
    }
}
