pragma solidity ^0.8.0;

contract NationalBioSecurityShield {
    event BioSecurityAlert(string shipment, string issue);

    function inspectShipment(string memory shipment, bool deceptiveLabel) public {
        if (deceptiveLabel) {
            emit BioSecurityAlert(shipment, "Deceptive labeling detected – biosecurity risk");
        }
    }
}
