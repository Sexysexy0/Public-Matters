pragma solidity ^0.8.19;

contract BarangayPraiseRouter {
    struct PraisePacket {
        string barangay;
        uint8 joyIndex;
        string topContractor;
        string civicQuote;
        uint256 broadcastDate;
    }

    PraisePacket[] public broadcasts;

    function routePraise(
        string memory _barangay,
        uint8 _joyIndex,
        string memory _topContractor,
        string memory _civicQuote,
        uint256 _broadcastDate
    ) public {
        broadcasts.push(PraisePacket(_barangay, _joyIndex, _topContractor, _civicQuote, _broadcastDate));
    }

    function getPraise(uint256 index) public view returns (PraisePacket memory) {
        require(index < broadcasts.length, "Invalid index");
        return broadcasts[index];
    }
}
