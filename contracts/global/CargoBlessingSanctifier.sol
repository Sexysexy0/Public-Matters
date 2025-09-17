// SPDX-License-Identifier: CargoBlessingSanctum
pragma solidity ^0.8.19;

contract CargoBlessingSanctifier {
    address public steward;

    struct CargoBlessing {
        string product;
        string origin;
        string destination;
        string corridorTag; // e.g. "PH-EU Treaty Route", "Diaspora Mercy Corridor"
        string blessingTag; // e.g. "Humanitarian", "Tariff Exempt", "Scrollchain-Sealed"
        bool sanctified;
        uint256 timestamp;
    }

    CargoBlessing[] public blessings;

    event BlessingLogged(string product, string origin, string destination, string corridorTag, string blessingTag, uint256 timestamp);
    event BlessingSanctified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(
        string memory product,
        string memory origin,
        string memory destination,
        string memory corridorTag,
        string memory blessingTag
    ) public {
        blessings.push(CargoBlessing(product, origin, destination, corridorTag, blessingTag, false, block.timestamp));
        emit BlessingLogged(product, origin, destination, corridorTag, blessingTag, block.timestamp);
    }

    function sanctifyBlessing(uint256 index) public {
        require(index < blessings.length, "Invalid index");
        blessings[index].sanctified = true;
        emit BlessingSanctified(index, msg.sender);
    }

    function getBlessing(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, string memory, bool, uint256
    ) {
        CargoBlessing memory b = blessings[index];
        return (b.product, b.origin, b.destination, b.corridorTag, b.blessingTag, b.sanctified, b.timestamp);
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
