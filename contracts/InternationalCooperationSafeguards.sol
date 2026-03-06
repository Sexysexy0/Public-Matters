// InternationalCooperationSafeguards.sol
pragma solidity ^0.8.0;

contract InternationalCooperationSafeguards {
    struct Alliance {
        uint256 id;
        string partner;    // e.g. "ASEAN"
        string safeguard;  // e.g. "Strengthen alliances for peace and progress"
        uint256 timestamp;
    }

    uint256 public allianceCount;
    mapping(uint256 => Alliance) public alliances;

    event AllianceLogged(uint256 id, string partner, string safeguard);

    function logAlliance(string memory partner, string memory safeguard) public {
        allianceCount++;
        alliances[allianceCount] = Alliance(allianceCount, partner, safeguard, block.timestamp);
        emit AllianceLogged(allianceCount, partner, safeguard);
    }
}
