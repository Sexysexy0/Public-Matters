pragma solidity ^0.8.0;

contract ProductStorageSupport {
    event StorageActivation(string sector, string issue);

    function checkOversupply(string memory sector, bool oversupply) public {
        if (oversupply) {
            emit StorageActivation(sector, "Government storage support activated");
        }
    }
}
