pragma solidity ^0.8.20;

contract MarineSurveillanceProtocol {
    address public admin;

    struct Surveillance {
        string location;     // e.g. West Philippine Sea
        string isotope;      // e.g. iodine-129
        string finding;      // e.g. elevated concentration 1.5–1.7x
        uint256 timestamp;
    }

    Surveillance[] public surveillances;

    event SurveillanceLogged(string location, string isotope, string finding, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSurveillance(string calldata location, string calldata isotope, string calldata finding) external onlyAdmin {
        surveillances.push(Surveillance(location, isotope, finding, block.timestamp));
        emit SurveillanceLogged(location, isotope, finding, block.timestamp);
    }

    function totalSurveillances() external view returns (uint256) {
        return surveillances.length;
    }
}
