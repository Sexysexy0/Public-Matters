// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CorporateEquityShield {
    struct CorporateAction {
        address stakeholder;
        string company;
        string decision;
        uint256 timestamp;
        bool safeguarded;
    }

    CorporateAction[] public actions;

    event ActionLogged(address indexed stakeholder, string company, string decision);
    event ActionSafeguarded(uint256 indexed id, address verifier);

    function logAction(string memory _company, string memory _decision) public {
        actions.push(CorporateAction(msg.sender, _company, _decision, block.timestamp, false));
        emit ActionLogged(msg.sender, _company, _decision);
    }

    function safeguardAction(uint256 _id) public {
        require(_id < actions.length, "Invalid ID");
        actions[_id].safeguarded = true;
        emit ActionSafeguarded(_id, msg.sender);
    }

    function getAction(uint256 _id) public view returns (CorporateAction memory) {
        require(_id < actions.length, "Invalid ID");
        return actions[_id];
    }

    function totalActions() public view returns (uint256) {
        return actions.length;
    }
}
