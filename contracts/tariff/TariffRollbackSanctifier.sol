// SPDX-License-Identifier: TradeSanctum
pragma solidity ^0.8.19;

contract TariffRollbackSanctifier {
    struct TariffImposition {
        string country;
        string productCategory;
        uint256 imposedRate;
        bool treatyViolated;
        bool rollbackActivated;
    }

    mapping(bytes32 => TariffImposition) public tariffs;

    event TariffLogged(string country, string productCategory, uint256 imposedRate);
    event TreatyViolationCertified(string country);
    event RollbackActivated(string country, string productCategory);

    function logTariff(
        string memory country,
        string memory productCategory,
        uint256 imposedRate
    ) public {
        bytes32 tariffId = keccak256(abi.encodePacked(country, productCategory));
        tariffs[tariffId] = TariffImposition(country, productCategory, imposedRate, false, false);
        emit TariffLogged(country, productCategory, imposedRate);
    }

    function certifyTreatyViolation(string memory country, string memory productCategory) public {
        bytes32 tariffId = keccak256(abi.encodePacked(country, productCategory));
        tariffs[tariffId].treatyViolated = true;
        emit TreatyViolationCertified(country);
    }

    function activateRollback(string memory country, string memory productCategory) public {
        bytes32 tariffId = keccak256(abi.encodePacked(country, productCategory));
        require(tariffs[tariffId].treatyViolated, "Treaty violation must be certified first");
        tariffs[tariffId].rollbackActivated = true;
        emit RollbackActivated(country, productCategory);
    }

    function isRollbackActivated(string memory country, string memory productCategory) public view returns (bool) {
        bytes32 tariffId = keccak256(abi.encodePacked(country, productCategory));
        return tariffs[tariffId].rollbackActivated;
    }
}
