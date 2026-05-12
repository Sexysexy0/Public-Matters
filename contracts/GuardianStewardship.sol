// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GuardianStewardship {
    struct StewardAction {
        address guardian;
        string covenant;
        uint256 timestamp;
        bool honored;
    }

    StewardAction[] public actions;

    event ActionLogged(address indexed guardian, string covenant);
    event ActionHonored(uint256 indexed id, address verifier);

    function logAction(string memory _covenant) public {
        actions.push(StewardAction(msg.sender, _covenant, block.timestamp, false));
        emit ActionLogged(msg.sender, _covenant);
    }

    function honorAction(uint256 _id) public {
        require(_id < actions.length, "Invalid ID");
        actions[_id].honored = true;
        emit ActionHonored(_id, msg.sender);
    }

    function getAction(uint256 _id) public view returns (StewardAction memory) {
        require(_id < actions.length, "Invalid ID");
        return actions[_id];
    }

    function totalActions() public view returns (uint256) {
        return actions.length;
    }
}
