pragma solidity ^0.8.20;

contract PatchPostureProtocol {
    address public admin;
    struct Posture { string system; string status; uint256 timestamp; }
    Posture[] public postures;
    event PostureLogged(string system, string status, uint256 timestamp);
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }
    function logPosture(string calldata system, string calldata status) external onlyAdmin {
        postures.push(Posture(system, status, block.timestamp));
        emit PostureLogged(system, status, block.timestamp);
    }
}
