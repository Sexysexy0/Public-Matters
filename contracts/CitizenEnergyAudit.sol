pragma solidity ^0.8.0;

contract CitizenEnergyAudit {
    event FuelReport(address indexed citizen, string station, uint256 price);

    function submitReport(string memory station, uint256 price) public {
        emit FuelReport(msg.sender, station, price);
    }
}
