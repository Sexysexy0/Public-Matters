pragma solidity ^0.8.20;

contract MacroResolutionProtocol {
    address public admin;

    struct Resolution {
        string event;        // e.g. US government shutdown negotiations
        string status;       // e.g. unresolved, progress, deal reached
        string impact;       // e.g. risk-off, stabilization, volatility
        uint256 timestamp;
    }

    Resolution[] public resolutions;

    event ResolutionLogged(string event, string status, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResolution(string calldata event, string calldata status, string calldata impact) external onlyAdmin {
        resolutions.push(Resolution(event, status, impact, block.timestamp));
        emit ResolutionLogged(event, status, impact, block.timestamp);
    }

    function totalResolutions() external view returns (uint256) {
        return resolutions.length;
    }
}
