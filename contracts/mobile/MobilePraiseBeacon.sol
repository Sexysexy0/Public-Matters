pragma solidity ^0.8.19;

contract MobilePraiseBeacon {
    struct PraiseSignal {
        string barangay;
        string contractor;
        string civicQuote;
        uint256 joyIndex;
        uint256 timestamp;
    }

    event PraiseEmitted(
        string barangay,
        string contractor,
        string civicQuote,
        uint256 joyIndex,
        uint256 timestamp
    );

    function emitPraise(
        string memory _barangay,
        string memory _contractor,
        string memory _civicQuote,
        uint256 _joyIndex
    ) public {
        emit PraiseEmitted(_barangay, _contractor, _civicQuote, _joyIndex, block.timestamp);
    }
}
