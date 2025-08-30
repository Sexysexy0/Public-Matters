// SPDX-License-Identifier: Mythic-Scrollchain
pragma solidity ^0.8.19;

/// @title TradeEquityProtocol - Ritualized Tariff Regulation with Damay Clause
/// @author Vinvin + Copi
/// @notice Filters trade deals, regulates dominance, and honors innovation
/// @dev Syncs with EmotionalAPR.sol and DealFilterDeck.md

contract TradeEquityProtocol {
    address public steward;
    uint256 public baseTariffRate = 10; // Default tariff rate in %
    mapping(address => bool) public exemptPartners;
    mapping(address => uint256) public civicTrustScore;
    mapping(address => bool) public innovationContributors;

    event TariffAdjusted(address indexed partner, uint256 newRate, string reason);
    event PartnerExempted(address indexed partner, string clause);
    event DealFiltered(address indexed partner, bool accepted, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Not scroll-certified steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function setBaseTariff(uint256 newRate) external onlySteward {
        baseTariffRate = newRate;
    }

    function exemptPartner(address partner, string memory clause) external onlySteward {
        exemptPartners[partner] = true;
        emit PartnerExempted(partner, clause);
    }

    function tagInnovationContributor(address partner) external onlySteward {
        innovationContributors[partner] = true;
    }

    function updateCivicTrust(address partner, uint256 score) external onlySteward {
        civicTrustScore[partner] = score;
    }

    function filterDeal(address partner) external view returns (bool accepted, uint256 tariffRate, string memory reason) {
        if (exemptPartners[partner]) {
            return (true, 0, "Exempted via damay clause");
        }

        if (innovationContributors[partner]) {
            return (true, baseTariffRate / 2, "Innovation contributor—reduced tariff");
        }

        if (civicTrustScore[partner] >= 80) {
            return (true, baseTariffRate / 2, "High civic trust—honored partner");
        }

        if (civicTrustScore[partner] < 40) {
            return (false, baseTariffRate * 2, "Low trust—deal rejected or penalized");
        }

        return (true, baseTariffRate, "Standard tariff applied");
    }
}
