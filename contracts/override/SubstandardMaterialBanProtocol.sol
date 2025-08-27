// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract SubstandardMaterialBanProtocol {
    address public steward;

    struct Material {
        string name;
        string supplier;
        uint256 qualityScore;
        bool isApproved;
        bool isSubstandard;
    }

    Material[] public materials;

    event MaterialLogged(string name, string supplier);
    event MaterialApproved(string name, string status);
    event MaterialRejected(string name, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized material audit.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logMaterial(string memory name, string memory supplier, uint256 qualityScore) public onlySteward {
        bool substandard = qualityScore < 75;
        bool approved = !substandard;

        materials.push(Material({
            name: name,
            supplier: supplier,
            qualityScore: qualityScore,
            isApproved: approved,
            isSubstandard: substandard
        }));

        emit MaterialLogged(name, supplier);

        if (approved) {
            emit MaterialApproved(name, "Approved. Quality meets civic standard.");
        } else {
            emit MaterialRejected(name, "Rejected. Substandard material detected.");
        }
    }

    function auditMaterial(uint256 index) public view returns (string memory) {
        Material memory m = materials[index];
        return string(abi.encodePacked(
            "Material: ", m.name,
            " | Supplier: ", m.supplier,
            " | Quality Score: ", uint2str(m.qualityScore),
            " | Approved: ", m.isApproved ? "Yes" : "No",
            " | Substandard: ", m.isSubstandard ? "Yes" : "No"
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
