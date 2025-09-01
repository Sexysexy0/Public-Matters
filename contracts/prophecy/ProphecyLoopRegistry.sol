// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ProphecyLoopRegistry {
    struct ProphecyLoop {
        string source;
        string signalType;
        string emotionalTag;
        string civicDomain;
        uint256 resonanceScore;
        uint256 timestamp;
    }

    ProphecyLoop[] public loops;

    event ProphecyLogged(string source, string signalType, string emotionalTag, uint256 resonanceScore);

    function logProphecy(
        string memory _source,
        string memory _signalType,
        string memory _emotionalTag,
        string memory _civicDomain,
        uint256 _resonanceScore
    ) public {
        loops.push(ProphecyLoop(
            _source,
            _signalType,
            _emotionalTag,
            _civicDomain,
            _resonanceScore,
            block.timestamp
        ));
        emit ProphecyLogged(_source, _signalType, _emotionalTag, _resonanceScore);
    }

    function getAllLoops() public view returns (ProphecyLoop[] memory) {
        return loops;
    }

    function getLatestLoop() public view returns (ProphecyLoop memory) {
        require(loops.length > 0, "No prophecy loops logged yet.");
        return loops[loops.length - 1];
    }
}
