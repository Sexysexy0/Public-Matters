// contracts/TradeShield.sol
pragma solidity ^0.8.20;

/**
 * @title TradeShield
 * @notice Logs protective measures in international trade.
 */
contract TradeShield {
    address public admin;

    struct Measure {
        string type;        // "Tariff", "ExportControl", "FairTrade"
        string description;
        uint256 timestamp;
    }

    Measure[] public measures;

    event MeasureLogged(string type, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logMeasure(string calldata type, string calldata description) external onlyAdmin {
        measures.push(Measure(type, description, block.timestamp));
        emit MeasureLogged(type, description, block.timestamp);
    }
}
