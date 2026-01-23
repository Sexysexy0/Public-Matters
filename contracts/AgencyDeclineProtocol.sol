pragma solidity ^0.8.20;

contract AgencyDeclineProtocol {
    address public admin;

    struct Decline {
        string agency;       // e.g. CIA
        string cause;        // e.g. funding cuts, political distrust
        string effect;       // e.g. talent loss, reliance on allies
        uint256 timestamp;
    }

    Decline[] public declines;

    event DeclineLogged(string agency, string cause, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDecline(string calldata agency, string calldata cause, string calldata effect) external onlyAdmin {
        declines.push(Decline(agency, cause, effect, block.timestamp));
        emit DeclineLogged(agency, cause, effect, block.timestamp);
    }

    function totalDeclines() external view returns (uint256) {
        return declines.length;
    }
}
