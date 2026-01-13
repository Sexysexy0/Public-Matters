pragma solidity ^0.8.20;

contract TariffDecisionProtocol {
    address public supremeCourt;
    address public president;

    struct Ruling {
        string subject;      // e.g. tariff authority
        string outcome;      // e.g. upheld, struck down
        uint256 timestamp;
    }

    Ruling[] public rulings;

    event RulingLogged(string subject, string outcome, uint256 timestamp);

    constructor(address _president) {
        supremeCourt = msg.sender;
        president = _president;
    }

    modifier onlyCourt() { require(msg.sender == supremeCourt, "Not Supreme Court"); _; }

    function logRuling(string calldata subject, string calldata outcome) external onlyCourt {
        rulings.push(Ruling(subject, outcome, block.timestamp));
        emit RulingLogged(subject, outcome, block.timestamp);
    }

    function totalRulings() external view returns (uint256) {
        return rulings.length;
    }
}
