pragma solidity ^0.8.0;

contract PathogenTransportRegistry {
    event RegistryEntry(string caseName, string status);

    function logCase(string memory caseName, string memory status) public {
        emit RegistryEntry(caseName, status);
    }
}
