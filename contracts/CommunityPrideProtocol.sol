pragma solidity ^0.8.20;

contract CommunityPrideProtocol {
    address public admin;

    struct Pride {
        string barangay;     // e.g. Bangkal
        string achievement;  // e.g. won match, best boxer
        string cheer;        // e.g. "Bangkal Pride!"
        uint256 timestamp;
    }

    Pride[] public prides;

    event PrideLogged(string barangay, string achievement, string cheer, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPride(string calldata barangay, string calldata achievement, string calldata cheer) external onlyAdmin {
        prides.push(Pride(barangay, achievement, cheer, block.timestamp));
        emit PrideLogged(barangay, achievement, cheer, block.timestamp);
    }

    function totalPrides() external view returns (uint256) {
        return prides.length;
    }
}
