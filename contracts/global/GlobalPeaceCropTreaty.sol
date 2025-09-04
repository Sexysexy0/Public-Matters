// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalPeaceCropTreaty {
    address public steward;
    mapping(string => bool) public treatySigned;
    string[] public participatingNations;
    uint256 public globalRevenueForecast;

    event TreatySigned(string nation);
    event GlobalForecastUpdated(uint256 amount);
    event TreatyActivated(address indexed steward, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function signTreaty(string memory _nation) public {
        require(!treatySigned[_nation], "Nation already signed");
        treatySigned[_nation] = true;
        participatingNations.push(_nation);
        emit TreatySigned(_nation);
    }

    function updateGlobalForecast(uint256 _amount) public {
        require(msg.sender == steward, "Only steward may update forecast");
        globalRevenueForecast = _amount;
        emit GlobalForecastUpdated(_amount);
        emit TreatyActivated(steward, block.timestamp);
    }

    function treatyStatus(string memory _nation) public view returns (string memory) {
        return treatySigned[_nation] ? "✅ Signed" : "⛔ Pending";
    }

    function totalParticipants() public view returns (uint256) {
        return participatingNations.length;
    }
}
