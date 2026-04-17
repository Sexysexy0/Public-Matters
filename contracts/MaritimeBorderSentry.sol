// MaritimeBorderSentry.sol
pragma solidity ^0.8.0;

contract MaritimeBorderSentry {
    struct Vessel {
        string name;
        string nationality;
        bool hasPermit;
        uint256 lastSeenLat;
        uint256 lastSeenLong;
    }

    mapping(string => Vessel) public monitoredVessels;

    event IncursionDetected(string vesselName, uint256 timestamp);

    function reportIncursion(string memory _vesselName, string memory _nationality, bool _permit) public {
        if (!_permit) {
            monitoredVessels[_vesselName] = Vessel(_vesselName, _nationality, false, 0, 0);
            emit IncursionDetected(_vesselName, block.timestamp);
        }
    }
}
