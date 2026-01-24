pragma solidity ^0.8.20;

contract StrikeTrackerProtocol {
    address public admin;

    struct Strike {
        string location;     // e.g. Minnesota, 215+ US cities
        uint256 closures;    // e.g. 737 businesses
        string source;       // e.g. crowdsourced list, Payday Report
        uint256 timestamp;
    }

    Strike[] public strikes;

    event StrikeLogged(string location, uint256 closures, string source, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logStrike(string calldata location, uint256 closures, string calldata source) external onlyAdmin {
        strikes.push(Strike(location, closures, source, block.timestamp));
        emit StrikeLogged(location, closures, source, block.timestamp);
    }

    function totalStrikes() external view returns (uint256) {
        return strikes.length;
    }
}
