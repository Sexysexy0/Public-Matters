pragma solidity ^0.8.20;

contract HumanRightsProtocol {
    address public admin;

    struct Right {
        string traveler;     // e.g. OFW, tourist
        string violation;    // e.g. denied boarding, harassment
        string principle;    // e.g. freedom of movement, dignity
        uint256 timestamp;
    }

    Right[] public rights;

    event RightLogged(string traveler, string violation, string principle, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRight(string calldata traveler, string calldata violation, string calldata principle) external onlyAdmin {
        rights.push(Right(traveler, violation, principle, block.timestamp));
        emit RightLogged(traveler, violation, principle, block.timestamp);
    }

    function totalRights() external view returns (uint256) {
        return rights.length;
    }
}
