// SPDX-License-Identifier: ExportSanctum
pragma solidity ^0.8.19;

contract ExportMomentumRouter {
    struct Export {
        string product;
        string destination;
        bool tariffExempt;
        uint256 incentiveAmount;
    }

    mapping(bytes32 => Export) public exports;

    event ExportTagged(string product, string destination, bool tariffExempt);
    event IncentiveGranted(string product, uint256 amount);

    function tagExport(string memory product, string memory destination, bool tariffExempt) public {
        bytes32 exportId = keccak256(abi.encodePacked(product, destination));
        exports[exportId] = Export(product, destination, tariffExempt, 0);
        emit ExportTagged(product, destination, tariffExempt);
    }

    function grantIncentive(string memory product, string memory destination, uint256 amount) public {
        bytes32 exportId = keccak256(abi.encodePacked(product, destination));
        exports[exportId].incentiveAmount = amount;
        emit IncentiveGranted(product, amount);
    }

    function getExportStatus(string memory product, string memory destination) public view returns (Export memory) {
        bytes32 exportId = keccak256(abi.encodePacked(product, destination));
        return exports[exportId];
    }
}
