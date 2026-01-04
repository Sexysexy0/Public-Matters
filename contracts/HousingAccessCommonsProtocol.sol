pragma solidity ^0.8.20;

contract HousingAccessCommonsProtocol {
    address public admin;

    struct Housing {
        string beneficiary;   // e.g. minimum wage earner, family
        string type;          // e.g. resilient housing, communal shelter
        uint256 timestamp;
    }

    Housing[] public housings;

    event HousingLogged(string beneficiary, string type, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logHousing(string calldata beneficiary, string calldata type) external onlyAdmin {
        housings.push(Housing(beneficiary, type, block.timestamp));
        emit HousingLogged(beneficiary, type, block.timestamp);
    }

    function totalHousings() external view returns (uint256) {
        return housings.length;
    }
}
