pragma solidity ^0.8.20;

contract LegalObserverProtocol {
    address public admin;

    struct Observer {
        string name;         // e.g. Renee Good
        string role;         // e.g. legal observer, rights monitor
        string incident;     // e.g. protest observation, ICE crackdown
        uint256 timestamp;
    }

    Observer[] public observers;

    event ObserverLogged(string name, string role, string incident, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logObserver(string calldata name, string calldata role, string calldata incident) external onlyAdmin {
        observers.push(Observer(name, role, incident, block.timestamp));
        emit ObserverLogged(name, role, incident, block.timestamp);
    }

    function totalObservers() external view returns (uint256) {
        return observers.length;
    }
}
