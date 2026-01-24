pragma solidity ^0.8.20;

contract InstitutionalAdoptionProtocol {
    address public admin;

    struct Adoption {
        string institution;  // e.g. hedge fund, sovereign wealth fund, pension
        string method;       // e.g. direct BTC buy, ETF, custody solution
        string impact;       // e.g. liquidity, legitimacy, market stability
        uint256 timestamp;
    }

    Adoption[] public adoptions;

    event AdoptionLogged(string institution, string method, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAdoption(string calldata institution, string calldata method, string calldata impact) external onlyAdmin {
        adoptions.push(Adoption(institution, method, impact, block.timestamp));
        emit AdoptionLogged(institution, method, impact, block.timestamp);
    }

    function totalAdoptions() external view returns (uint256) {
        return adoptions.length;
    }
}
