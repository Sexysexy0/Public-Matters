// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.27;

contract StrategicDefenseFund {
    address public steward = msg.sender;
    mapping(string => uint256) public allocation;
    mapping(string => string) public sanctumNotes;

    event FundAllocated(string territory, uint256 amount, string note);

    function allocate(string memory territory, uint256 amount, string memory note) public {
        require(msg.sender == steward, "Unauthorized steward");
        allocation[territory] = amount;
        sanctumNotes[territory] = note;
        emit FundAllocated(territory, amount, note);
    }

    function getAllocation(string memory territory) public view returns (uint256) {
        return allocation[territory];
    }

    function getNote(string memory territory) public view returns (string memory) {
        return sanctumNotes[territory];
    }
}
