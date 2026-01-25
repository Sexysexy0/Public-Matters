pragma solidity ^0.8.20;

contract CentralBankIndependenceProtocol {
    address public admin;

    struct Independence {
        string era;          // e.g. 1920s, 1980s, 2020s
        string champion;     // e.g. Paul Volcker, Christine Lagarde
        string principle;    // e.g. price stability, autonomy, fiscal tension
        uint256 timestamp;
    }

    Independence[] public independences;

    event IndependenceLogged(string era, string champion, string principle, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIndependence(string calldata era, string calldata champion, string calldata principle) external onlyAdmin {
        independences.push(Independence(era, champion, principle, block.timestamp));
        emit IndependenceLogged(era, champion, principle, block.timestamp);
    }

    function totalIndependences() external view returns (uint256) {
        return independences.length;
    }
}
