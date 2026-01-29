pragma solidity ^0.8.20;

contract InstitutionalCooperationProtocol {
    address public admin;

    struct Cooperation {
        string institution;   // e.g. Ayala, BlackRock, JPMorgan
        string asset;         // e.g. Bitcoin
        string role;          // e.g. Holder, Custodian
        uint256 timestamp;
    }

    Cooperation[] public cooperations;

    event CooperationLogged(string institution, string asset, string role, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCooperation(string calldata institution, string calldata asset, string calldata role) external onlyAdmin {
        cooperations.push(Cooperation(institution, asset, role, block.timestamp));
        emit CooperationLogged(institution, asset, role, block.timestamp);
    }

    function totalCooperations() external view returns (uint256) {
        return cooperations.length;
    }
}
