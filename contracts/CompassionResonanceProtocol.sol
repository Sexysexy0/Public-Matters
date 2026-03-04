// CompassionResonanceProtocol.sol
pragma solidity ^0.8.0;

contract CompassionResonanceProtocol {
    struct Support {
        uint256 id;
        string community; // e.g. "Displaced Families"
        string gesture;   // e.g. "Scholarship program"
        string outcome;   // e.g. "Improved access to education"
        uint256 timestamp;
    }

    uint256 public supportCount;
    mapping(uint256 => Support) public supports;

    event SupportLogged(uint256 id, string community, string gesture, string outcome);

    function logSupport(string memory community, string memory gesture, string memory outcome) public {
        supportCount++;
        supports[supportCount] = Support(supportCount, community, gesture, outcome, block.timestamp);
        emit SupportLogged(supportCount, community, gesture, outcome);
    }
}
