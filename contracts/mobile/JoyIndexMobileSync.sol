pragma solidity ^0.8.19;

contract JoyIndexMobileSync {
    struct MobilePacket {
        string barangay;
        uint8 joyIndex;
        string topContractor;
        string civicQuote;
        uint256 timestamp;
        address steward;
    }

    MobilePacket[] public mobileBroadcasts;

    event MobileJoySynced(
        string barangay,
        uint8 joyIndex,
        string topContractor,
        string civicQuote,
        uint256 timestamp,
        address steward
    );

    function syncJoyToMobile(
        string memory _barangay,
        uint8 _joyIndex,
        string memory _topContractor,
        string memory _civicQuote
    ) public {
        MobilePacket memory packet = MobilePacket(
            _barangay,
            _joyIndex,
            _topContractor,
            _civicQuote,
            block.timestamp,
            msg.sender
        );

        mobileBroadcasts.push(packet);
        emit MobileJoySynced(_barangay, _joyIndex, _topContractor, _civicQuote, block.timestamp, msg.sender);
    }

    function getMobilePacket(uint256 index) public view returns (MobilePacket memory) {
        require(index < mobileBroadcasts.length, "Invalid index");
        return mobileBroadcasts[index];
    }

    function totalMobilePackets() public view returns (uint256) {
        return mobileBroadcasts.length;
    }
}
