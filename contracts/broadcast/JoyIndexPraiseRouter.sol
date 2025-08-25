pragma solidity ^0.8.19;

contract JoyIndexPraiseRouter {
    struct PraisePacket {
        string barangay;
        uint8 joyIndex;
        string topContractor;
        string civicQuote;
        bool isTopPerformer;
    }

    PraisePacket[] public routedPraises;

    event PraiseRouted(string barangay, uint8 joyIndex, string topContractor, string civicQuote, bool isTopPerformer);

    function routePraise(
        string memory _barangay,
        uint8 _joyIndex,
        string memory _topContractor,
        string memory _civicQuote
    ) public {
        bool top = _joyIndex >= 90;
        routedPraises.push(PraisePacket(_barangay, _joyIndex, _topContractor, _civicQuote, top));
        emit PraiseRouted(_barangay, _joyIndex, _topContractor, _civicQuote, top);
    }

    function getPraise(uint256 index) public view returns (PraisePacket memory) {
        require(index < routedPraises.length, "Invalid index");
        return routedPraises[index];
    }
}
