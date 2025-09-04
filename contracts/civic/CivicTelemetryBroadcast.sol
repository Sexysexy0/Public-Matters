// CivicTelemetryBroadcast.sol
// Broadcasts civic initiatives with emotional APR, agency metadata, and planetary blessing

pragma solidity ^0.8.19;

contract CivicTelemetryBroadcast {
    address public steward;

    struct CivicSignal {
        string initiative;
        string agency;
        string region;
        string status;
        string civicUseCase;
        uint256 emotionalAPR;
        uint256 timestamp;
        bool isBroadcasted;
    }

    CivicSignal[] public broadcasts;

    event SignalBroadcasted(
        string initiative,
        string agency,
        string region,
        string status,
        string civicUseCase,
        uint256 emotionalAPR,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function broadcastSignal(
        string memory initiative,
        string memory agency,
        string memory region,
        string memory status,
        string memory civicUseCase,
        uint256 emotionalAPR
    ) public onlySteward {
        uint256 nowTime = block.timestamp;
        broadcasts.push(CivicSignal(
            initiative,
            agency,
            region,
            status,
            civicUseCase,
            emotionalAPR,
            nowTime,
            true
        ));
        emit SignalBroadcasted(initiative, agency, region, status, civicUseCase, emotionalAPR, nowTime);
    }

    function getAllBroadcasts() public view returns (CivicSignal[] memory) {
        return broadcasts;
    }

    function getLatestBroadcast() public view returns (CivicSignal memory) {
        require(broadcasts.length > 0, "No broadcasts yet");
        return broadcasts[broadcasts.length - 1];
    }
}
