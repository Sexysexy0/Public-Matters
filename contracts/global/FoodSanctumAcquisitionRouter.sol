// SPDX-License-Identifier: CulinarySanctum
pragma solidity ^0.8.19;

contract FoodSanctumAcquisitionRouter {
    address public steward;

    struct Acquisition {
        string company;
        string buyer;
        string purpose;
        uint256 valuationUSD;
        uint256 timestamp;
        bool verified;
    }

    Acquisition[] public acquisitions;

    event AcquisitionLogged(string company, string buyer, uint256 valuationUSD, uint256 timestamp);
    event AcquisitionVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logAcquisition(
        string memory company,
        string memory buyer,
        string memory purpose,
        uint256 valuationUSD
    ) public {
        acquisitions.push(Acquisition(company, buyer, purpose, valuationUSD, block.timestamp, false));
        emit AcquisitionLogged(company, buyer, valuationUSD, block.timestamp);
    }

    function verifyAcquisition(uint256 index) public {
        require(index < acquisitions.length, "Invalid index");
        acquisitions[index].verified = true;
        emit AcquisitionVerified(index, msg.sender);
    }

    function getAcquisition(uint256 index) public view returns (
        string memory, string memory, string memory, uint256, uint256, bool
    ) {
        Acquisition memory a = acquisitions[index];
        return (a.company, a.buyer, a.purpose, a.valuationUSD, a.timestamp, a.verified);
    }

    function totalAcquisitions() public view returns (uint256) {
        return acquisitions.length;
    }
}
