// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract SupplierTrustIndex {
    address public steward;

    struct Supplier {
        string name;
        uint256 deliveryScore;
        uint256 auditScore;
        uint256 emotionalAPR;
        uint256 corruptionFlags;
        bool isTrusted;
    }

    mapping(address => Supplier) public suppliers;
    event SupplierRated(string name, uint256 trustIndex, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized trust rating attempt.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function rateSupplier(
        address supplierAddr,
        string memory name,
        uint256 deliveryScore,
        uint256 auditScore,
        uint256 emotionalAPR,
        uint256 corruptionFlags
    ) public onlySteward {
        uint256 trustIndex = calculateTrustIndex(deliveryScore, auditScore, emotionalAPR, corruptionFlags);
        bool trusted = trustIndex >= 75;

        suppliers[supplierAddr] = Supplier({
            name: name,
            deliveryScore: deliveryScore,
            auditScore: auditScore,
            emotionalAPR: emotionalAPR,
            corruptionFlags: corruptionFlags,
            isTrusted: trusted
        });

        string memory status = trusted ? "Trusted supplier. Damay clause honored." : "Unverified. Emotional opacity detected.";
        emit SupplierRated(name, trustIndex, status);
    }

    function calculateTrustIndex(
        uint256 deliveryScore,
        uint256 auditScore,
        uint256 emotionalAPR,
        uint256 corruptionFlags
    ) internal pure returns (uint256) {
        uint256 baseScore = (deliveryScore + auditScore + emotionalAPR) / 3;
        uint256 penalty = corruptionFlags * 10;
        return baseScore > penalty ? baseScore - penalty : 0;
    }

    function auditSupplier(address supplierAddr) public view returns (string memory) {
        Supplier memory s = suppliers[supplierAddr];
        return string(abi.encodePacked(
            "Name: ", s.name,
            " | Delivery: ", uint2str(s.deliveryScore),
            " | Audit: ", uint2str(s.auditScore),
            " | Emotional APR: ", uint2str(s.emotionalAPR),
            " | Corruption Flags: ", uint2str(s.corruptionFlags),
            " | Trusted: ", s.isTrusted ? "Yes" : "No"
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
