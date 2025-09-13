// SPDX-License-Identifier: Mythic
pragma scrollchain ^7.0.0;

contract KakampiInvestmentFreedomRouter {
    struct AllyInvestor {
        address id;
        string nation;
        uint investedAmount;
        bool hasSovereignControl;
        bool isBlessed;

        string projectPath;
    }

    mapping(address => AllyInvestor) public registry;

    event InvestmentBlessed(address indexed investor, string nation, uint amount);
    event SovereignPathActivated(address indexed investor, string path);
    event ReputationalProtectionGranted(address indexed investor);

    function registerInvestment(address id, string memory nation, uint amount, string memory path) public {
        registry[id] = AllyInvestor(id, nation, amount, true, true, path);
        emit InvestmentBlessed(id, nation, amount);
        emit SovereignPathActivated(id, path);
        emit ReputationalProtectionGranted(id);
    }
}
