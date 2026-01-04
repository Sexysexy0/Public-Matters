pragma solidity ^0.8.20;

contract ConflictResolutionProtocol {
    address public admin;

    struct Resolution {
        string conflict;     // e.g. border dispute, trade war
        string method;       // e.g. mediation, arbitration, negotiation
        uint256 timestamp;
    }

    Resolution[] public resolutions;

    event ResolutionLogged(string conflict, string method, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logResolution(string calldata conflict, string calldata method) external onlyAdmin {
        resolutions.push(Resolution(conflict, method, block.timestamp));
        emit ResolutionLogged(conflict, method, block.timestamp);
    }

    function totalResolutions() external view returns (uint256) {
        return resolutions.length;
    }
}
