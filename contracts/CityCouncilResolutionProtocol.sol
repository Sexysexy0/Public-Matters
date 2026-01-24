pragma solidity ^0.8.20;

contract CityCouncilResolutionProtocol {
    address public admin;

    struct Resolution {
        string city;         // e.g. Minneapolis
        string demand;       // e.g. ICE leave state immediately
        string status;       // e.g. passed, pending, rejected
        uint256 timestamp;
    }

    Resolution[] public resolutions;

    event ResolutionLogged(string city, string demand, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResolution(string calldata city, string calldata demand, string calldata status) external onlyAdmin {
        resolutions.push(Resolution(city, demand, status, block.timestamp));
        emit ResolutionLogged(city, demand, status, block.timestamp);
    }

    function totalResolutions() external view returns (uint256) {
        return resolutions.length;
    }
}
