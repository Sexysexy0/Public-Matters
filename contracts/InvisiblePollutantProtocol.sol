pragma solidity ^0.8.20;

contract InvisiblePollutantProtocol {
    address public admin;

    struct Pollutant {
        string typeOf;       // e.g. iodine-129
        string source;       // e.g. nuclear reprocessing, weapons testing
        string effect;       // e.g. marine monitoring, cross-border drift
        uint256 timestamp;
    }

    Pollutant[] public pollutants;

    event PollutantLogged(string typeOf, string source, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPollutant(string calldata typeOf, string calldata source, string calldata effect) external onlyAdmin {
        pollutants.push(Pollutant(typeOf, source, effect, block.timestamp));
        emit PollutantLogged(typeOf, source, effect, block.timestamp);
    }

    function totalPollutants() external view returns (uint256) {
        return pollutants.length;
    }
}
