pragma solidity ^0.8.20;

contract DataPurityProtocol {
    address public admin;

    struct Purity {
        string dataset;      // e.g. training corpus
        string risk;         // e.g. AI-on-AI contamination
        string safeguard;    // e.g. human curation, filtering
        uint256 timestamp;
    }

    Purity[] public purities;

    event PurityLogged(string dataset, string risk, string safeguard, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPurity(string calldata dataset, string calldata risk, string calldata safeguard) external onlyAdmin {
        purities.push(Purity(dataset, risk, safeguard, block.timestamp));
        emit PurityLogged(dataset, risk, safeguard, block.timestamp);
    }

    function totalPurities() external view returns (uint256) {
        return purities.length;
    }
}
