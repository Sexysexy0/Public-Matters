pragma solidity ^0.8.0;

contract FlatWageProtocol {
    event WageUpgrade(string worker, uint256 newWage);

    function adjustWage(string memory worker, uint256 currentWage) public {
        if (currentWage < 1000) {
            emit WageUpgrade(worker, 1000);
        }
    }
}
