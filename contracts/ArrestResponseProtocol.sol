pragma solidity ^0.8.20;

contract ArrestResponseProtocol {
    address public admin;

    struct Arrest {
        string incident;     // e.g. Dupax protest
        string number;       // e.g. 7 residents arrested
        string consequence;  // e.g. silencing, intimidation
        uint256 timestamp;
    }

    Arrest[] public arrests;

    event ArrestLogged(string incident, string number, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logArrest(string calldata incident, string calldata number, string calldata consequence) external onlyAdmin {
        arrests.push(Arrest(incident, number, consequence, block.timestamp));
        emit ArrestLogged(incident, number, consequence, block.timestamp);
    }

    function totalArrests() external view returns (uint256) {
        return arrests.length;
    }
}
