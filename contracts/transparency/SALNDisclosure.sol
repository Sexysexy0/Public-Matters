// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SALNDisclosure {
    event SALNFiled(string steward, uint256 timestamp, string region, uint256 assetValue, uint256 liabilityValue);
    event DisclosureFlagged(string steward, string reason);

    struct SALN {
        string steward;
        string region;
        uint256 assetValue;
        uint256 liabilityValue;
        uint256 timestamp;
    }

    mapping(string => SALN) public salns;
    uint256 public auditThreshold = 10000000; // Example: 10M PHP

    function fileSALN(string memory steward, string memory region, uint256 assets, uint256 liabilities) public {
        salns[steward] = SALN(steward, region, assets, liabilities, block.timestamp);
        emit SALNFiled(steward, block.timestamp, region, assets, liabilities);
        if (assets - liabilities > auditThreshold) {
            emit DisclosureFlagged(steward, "Asset-liability delta exceeds audit threshold");
        }
    }

    function getSALN(string memory steward) public view returns (SALN memory) {
        return salns[steward];
    }

    function updateAuditThreshold(uint256 newThreshold) public {
        auditThreshold = newThreshold;
    }
}
