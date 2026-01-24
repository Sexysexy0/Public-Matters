pragma solidity ^0.8.20;

contract CapitalFlightProtocol {
    address public admin;

    struct Capital {
        string source;       // e.g. private wealth, SOE funds
        string method;       // e.g. overseas transfer, crypto, hidden assets
        string impact;       // e.g. economic instability, currency drain
        uint256 timestamp;
    }

    Capital[] public capitals;

    event CapitalLogged(string source, string method, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCapital(string calldata source, string calldata method, string calldata impact) external onlyAdmin {
        capitals.push(Capital(source, method, impact, block.timestamp));
        emit CapitalLogged(source, method, impact, block.timestamp);
    }

    function totalCapitals() external view returns (uint256) {
        return capitals.length;
    }
}
