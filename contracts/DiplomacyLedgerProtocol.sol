pragma solidity ^0.8.20;

contract DiplomacyLedgerProtocol {
    address public admin;

    struct Agreement {
        string countryA;
        string countryB;
        string terms;        // e.g. trade pact, security alliance
        uint256 timestamp;
    }

    Agreement[] public agreements;

    event AgreementLogged(string countryA, string countryB, string terms, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAgreement(string calldata countryA, string calldata countryB, string calldata terms) external onlyAdmin {
        agreements.push(Agreement(countryA, countryB, terms, block.timestamp));
        emit AgreementLogged(countryA, countryB, terms, block.timestamp);
    }

    function totalAgreements() external view returns (uint256) {
        return agreements.length;
    }
}
