// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BarangayFallbackRouter {
    struct FallbackPath {
        address steward;
        string trigger;
        string destination;
        uint256 emotionalAPR;
        bool activated;
    }

    FallbackPath[] public paths;

    event FallbackRouted(address steward, string trigger, string destination, uint256 emotionalAPR);

    function routeFallback(
        address _steward,
        string memory _trigger,
        string memory _destination,
        uint256 _emotionalAPR
    ) public {
        paths.push(FallbackPath(_steward, _trigger, _destination, _emotionalAPR, true));
        emit FallbackRouted(_steward, _trigger, _destination, _emotionalAPR);
    }

    function getAllFallbacks() public view returns (FallbackPath[] memory) {
        return paths;
    }
}
