pragma solidity ^0.8.20;

contract MarketShareProtocol {
    address public admin;

    struct Share {
        string category;     // e.g. BEV, hybrid, petrol/diesel
        string percentage;   // e.g. 17.4%, 34.5%, 35.5%
        string trend;        // e.g. rising, stable, declining
        uint256 timestamp;
    }

    Share[] public shares;

    event ShareLogged(string category, string percentage, string trend, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logShare(string calldata category, string calldata percentage, string calldata trend) external onlyAdmin {
        shares.push(Share(category, percentage, trend, block.timestamp));
        emit ShareLogged(category, percentage, trend, block.timestamp);
    }

    function totalShares() external view returns (uint256) {
        return shares.length;
    }
}
