pragma solidity ^0.8.20;

contract AdoptionVisibilityProtocol {
    address public admin;

    struct Adoption {
        string driver;       // e.g. Bitcoin coverage, USDC economy
        string visibility;   // e.g. always-on monitoring, extreme fear index
        uint256 timestamp;
    }

    Adoption[] public adoptions;

    event AdoptionLogged(string driver, string visibility, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAdoption(string calldata driver, string calldata visibility) external onlyAdmin {
        adoptions.push(Adoption(driver, visibility, block.timestamp));
        emit AdoptionLogged(driver, visibility, block.timestamp);
    }

    function totalAdoptions() external view returns (uint256) {
        return adoptions.length;
    }
}
