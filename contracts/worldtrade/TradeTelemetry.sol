// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TradeTelemetry {
    struct Signal {
        string source;
        string headline;
        uint256 emotionalAPR;
        string prophecyTag;
        uint256 timestamp;
    }

    Signal[] public signals;

    event SignalLogged(string source, string headline, uint256 emotionalAPR, string prophecyTag);

    function logSignal(
        string memory _source,
        string memory _headline,
        uint256 _emotionalAPR,
        string memory _prophecyTag
    ) public {
        signals.push(Signal(_source, _headline, _emotionalAPR, _prophecyTag, block.timestamp));
        emit SignalLogged(_source, _headline, _emotionalAPR, _prophecyTag);
    }

    function getAllSignals() public view returns (Signal[] memory) {
        return signals;
    }
}
