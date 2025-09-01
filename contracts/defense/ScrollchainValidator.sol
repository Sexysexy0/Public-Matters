// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollchainValidator {
    struct Scroll {
        string name;
        uint256 emotionalAPR;
        uint256 civicResonance;
        string scope;
        bool isValid;
        uint256 timestamp;
    }

    Scroll[] public scrolls;

    event ScrollValidated(
        string name,
        uint256 emotionalAPR,
        uint256 civicResonance,
        string scope,
        bool isValid,
        uint256 timestamp
    );

    function validateScroll(
        string memory _name,
        uint256 _emotionalAPR,
        uint256 _civicResonance,
        string memory _scope
    ) public {
        bool valid = (_emotionalAPR >= 60 && _civicResonance >= 70);
        uint256 time = block.timestamp;

        scrolls.push(Scroll(_name, _emotionalAPR, _civicResonance, _scope, valid, time));
        emit ScrollValidated(_name, _emotionalAPR, _civicResonance, _scope, valid, time);
    }

    function getAllScrolls() public view returns (Scroll[] memory) {
        return scrolls;
    }
}
