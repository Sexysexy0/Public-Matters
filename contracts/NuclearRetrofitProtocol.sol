pragma solidity ^0.8.20;

contract NuclearRetrofitProtocol {
    address public admin;

    struct Retrofit {
        string upgrade;      // e.g. seismic reinforcement, cooling system replacement
        string purpose;      // e.g. safety, compliance
        string status;       // e.g. planned, ongoing, completed
        uint256 timestamp;
    }

    Retrofit[] public retrofits;

    event RetrofitLogged(string upgrade, string purpose, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRetrofit(string calldata upgrade, string calldata purpose, string calldata status) external onlyAdmin {
        retrofits.push(Retrofit(upgrade, purpose, status, block.timestamp));
        emit RetrofitLogged(upgrade, purpose, status, block.timestamp);
    }

    function totalRetrofits() external view returns (uint256) {
        return retrofits.length;
    }
}
