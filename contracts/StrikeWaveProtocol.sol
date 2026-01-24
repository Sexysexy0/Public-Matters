pragma solidity ^0.8.20;

contract StrikeWaveProtocol {
    address public admin;

    struct Strike {
        string location;     // e.g. Minnesota, New York
        uint256 closures;    // e.g. 737 businesses
        string support;      // e.g. unions, faith groups, city council
        uint256 timestamp;
    }

    Strike[] public strikes;

    event StrikeLogged(string location, uint256 closures, string support, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logStrike(string calldata location, uint256 closures, string calldata support) external onlyAdmin {
        strikes.push(Strike(location, closures, support, block.timestamp));
        emit StrikeLogged(location, closures, support, block.timestamp);
    }

    function totalStrikes() external view returns (uint256) {
        return strikes.length;
    }
}
