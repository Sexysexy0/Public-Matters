// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EvolutionarySelectionVault {
    struct Selection {
        address participant;
        string trait;
        uint256 timestamp;
        bool safeguarded;
    }

    Selection[] public selections;

    event SelectionLogged(address indexed participant, string trait);
    event SelectionSafeguarded(uint256 indexed id, address verifier);

    function logSelection(string memory _trait) public {
        selections.push(Selection(msg.sender, _trait, block.timestamp, false));
        emit SelectionLogged(msg.sender, _trait);
    }

    function safeguardSelection(uint256 _id) public {
        require(_id < selections.length, "Invalid ID");
        selections[_id].safeguarded = true;
        emit SelectionSafeguarded(_id, msg.sender);
    }

    function getSelection(uint256 _id) public view returns (Selection memory) {
        require(_id < selections.length, "Invalid ID");
        return selections[_id];
    }

    function totalSelections() public view returns (uint256) {
        return selections.length;
    }
}
