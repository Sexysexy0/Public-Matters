pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract NationalBioSecurityShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event BioSecurityAlert(string shipment, string issue);

    function inspectShipment(string memory shipment, bool deceptiveLabel) public {
        if (deceptiveLabel) {
            emit BioSecurityAlert(shipment, "Deceptive labeling detected – biosecurity risk");
        }
    }
}
