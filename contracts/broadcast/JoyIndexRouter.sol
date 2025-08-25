pragma solidity ^0.8.19;

contract JoyIndexRouter {
    struct JoyPacket {
        string barangay;
        uint8 joyIndex;
        string topContractor;
        string civicQuote;
        uint256 broadcastDate;
    }

    JoyPacket[] public broadcasts;

    event JoyBroadcasted(
        string barangay,
        uint8 joyIndex,
        string topContractor,
        string civicQuote,
        uint256 broadcastDate
    );

    function routeJoy(
        string memory _barangay,
        uint8 _joyIndex,
        string memory _topContractor,
        string memory _civicQuote,
        uint256 _broadcastDate
    ) public {
        JoyPacket memory packet = JoyPacket(_barangay, _joyIndex, _topContractor, _civicQuote, _broadcastDate);
        broadcasts.push(packet);
        emit JoyBroadcasted(_barangay, _joyIndex, _topContractor, _civicQuote, _broadcastDate);
    }

    function getBroadcast(uint256 index) public view returns (JoyPacket memory) {
        require(index < broadcasts.length, "Invalid index");
        return broadcasts[index];
    }

    function totalBroadcasts() public view returns (uint256) {
        return broadcasts.length;
    }
}
