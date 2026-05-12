// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AthleticRootsBridge {
    struct Transition {
        address athlete;
        string origin;
        string pivot;
        uint256 timestamp;
        bool safeguarded;
    }

    Transition[] public transitions;

    event TransitionLogged(address indexed athlete, string origin, string pivot);
    event TransitionSafeguarded(uint256 indexed id, address verifier);

    function logTransition(string memory _origin, string memory _pivot) public {
        transitions.push(Transition(msg.sender, _origin, _pivot, block.timestamp, false));
        emit TransitionLogged(msg.sender, _origin, _pivot);
    }

    function safeguardTransition(uint256 _id) public {
        require(_id < transitions.length, "Invalid ID");
        transitions[_id].safeguarded = true;
        emit TransitionSafeguarded(_id, msg.sender);
    }

    function getTransition(uint256 _id) public view returns (Transition memory) {
        require(_id < transitions.length, "Invalid ID");
        return transitions[_id];
    }

    function totalTransitions() public view returns (uint256) {
        return transitions.length;
    }
}
