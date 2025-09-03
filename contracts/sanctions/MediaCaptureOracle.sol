// MediaCaptureOracle.sol
pragma solidity ^0.8.19;

contract MediaCaptureOracle {
    address public steward;

    struct MediaLog {
        string source;
        string location;
        string timestampedFootage;
        bool synced;
    }

    MediaLog[] public logs;

    event MediaSynced(string source, string location);

    constructor() {
        steward = msg.sender;
    }

    function syncMedia(string memory source, string memory location, string memory footageLink) public {
        logs.push(MediaLog(source, location, footageLink, true));
        emit MediaSynced(source, location);
    }

    function getLogs() public view returns (MediaLog[] memory) {
        return logs;
    }
}
