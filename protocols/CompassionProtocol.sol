// CompassionProtocol.sol
pragma solidity ^0.8.0;

contract CompassionProtocol {
    struct Act {
        uint256 id;
        string subject;   // e.g. "Mary Jane Veloso"
        string gesture;   // e.g. "Executive Clemency", "Humanitarian Visit"
        uint256 timestamp;
    }

    uint256 public actCount;
    mapping(uint256 => Act) public acts;

    event ActLogged(uint256 id, string subject, string gesture, uint256 timestamp);
    event CompassionDeclared(string message);

    function logAct(string memory subject, string memory gesture) public {
        actCount++;
        acts[actCount] = Act(actCount, subject, gesture, block.timestamp);
        emit ActLogged(actCount, subject, gesture, block.timestamp);
    }

    function declareCompassion() public {
        emit CompassionDeclared("Compassion Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
