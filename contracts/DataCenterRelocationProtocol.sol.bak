// DataCenterRelocationProtocol.sol
pragma solidity ^0.8.0;

contract DataCenterRelocationProtocol {
    struct Facility {
        uint256 id;
        string location;   // e.g. "Desert Zone Alpha"
        string type;       // e.g. "AI Data Center"
        bool active;
        uint256 timestamp;
    }

    uint256 public facilityCount;
    mapping(uint256 => Facility) public facilities;

    event FacilityActivated(uint256 id, string location, string type);

    function activateFacility(string memory location, string memory type) public {
        facilityCount++;
        facilities[facilityCount] = Facility(facilityCount, location, type, true, block.timestamp);
        emit FacilityActivated(facilityCount, location, type);
    }
}
