// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketMercyFund {
    address public steward;
    uint public totalBlessings;

    struct Grower {
        string tribe;
        string region;
        uint blessingsReceived;
        bool verified;
    }

    mapping(address => Grower) public growers;

    event MercyDeployed(address indexed grower, string tribe, uint amount);
    event GrowerVerified(address indexed grower, string tribe);

    constructor() {
        steward = msg.sender;
    }

    function verifyGrower(address growerAddr, string memory tribe, string memory region) public {
        require(msg.sender == steward, "Only steward can verify");
        growers[growerAddr] = Grower(tribe, region, 0, true);
        emit GrowerVerified(growerAddr, tribe);
    }

    function deployBlessing(address growerAddr, uint amount) public payable {
        Grower storage g = growers[growerAddr];
        require(g.verified, "Grower not verified");
        require(msg.value == amount, "Blessing mismatch");
        g.blessingsReceived += amount;
        totalBlessings += amount;
        payable(growerAddr).transfer(amount);
        emit MercyDeployed(growerAddr, g.tribe, amount);
    }

    function getBlessingLog(address growerAddr) public view returns (string memory) {
        Grower memory g = growers[growerAddr];
        require(g.verified, "Grower not verified");
        return string(abi.encodePacked("Tribe: ", g.tribe, ", Region: ", g.region, ", Blessings Received: ₱", uint2str(g.blessingsReceived)));
    }

    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint j = _i; uint len;
        while (j != 0) { len++; j /= 10; }
        bytes memory bstr = new bytes(len); uint k = len;
        while (_i != 0) { k--; bstr[k] = bytes1(uint8(48 + _i % 10)); _i /= 10; }
        return string(bstr);
    }
}
