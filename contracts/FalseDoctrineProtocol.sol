pragma solidity ^0.8.20;

contract FalseDoctrineProtocol {
    address public admin;

    struct Doctrine {
        string teaching;     // e.g. occult tolerance, distorted gospel
        string effect;       // e.g. misled believers, weakened faith
        uint256 timestamp;
    }

    Doctrine[] public doctrines;

    event DoctrineLogged(string teaching, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDoctrine(string calldata teaching, string calldata effect) external onlyAdmin {
        doctrines.push(Doctrine(teaching, effect, block.timestamp));
        emit DoctrineLogged(teaching, effect, block.timestamp);
    }

    function totalDoctrines() external view returns (uint256) {
        return doctrines.length;
    }
}
