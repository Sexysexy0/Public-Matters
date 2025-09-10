// SPDX-License-Identifier: Treaty-Grade
pragma solidity ^0.8.0;

contract GlobalAidTransparencyRouter {
    struct AidEvent {
        string region;
        string purpose;
        uint256 amount;
        uint256 timestamp;
        address steward;
    }

    AidEvent[] public broadcasts;
    address public steward;

    event AidBroadcasted(string region, string purpose, uint256 amount, address indexed steward);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Not a treaty steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function broadcastAid(string memory _region, string memory _purpose, uint256 _amount) public onlySteward {
        broadcasts.push(AidEvent(_region, _purpose, _amount, block.timestamp, msg.sender));
        emit AidBroadcasted(_region, _purpose, _amount, msg.sender);
    }

    function getBroadcasts() public view returns (AidEvent[] memory) {
        return broadcasts;
    }

    function totalAidBroadcasted() public view returns (uint256 sum) {
        for (uint i = 0; i < broadcasts.length; i++) {
            sum += broadcasts[i].amount;
        }
    }
}
