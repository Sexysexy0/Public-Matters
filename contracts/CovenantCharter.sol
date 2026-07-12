// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Charter
/// @notice Constitutional backbone of the Public Matters covenant system
contract CovenantCharter {
    address public guardian;
    uint256 public articleCount;

    struct Article {
        uint256 id;
        string title;
        string content;
        bool active;
    }

    mapping(uint256 => Article) public articles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event ArticleAdded(uint256 indexed id, string title);
    event ArticleUpdated(uint256 indexed id, string title);
    event ArticleStatusChanged(uint256 indexed id, bool active);

    constructor() {
        guardian = msg.sender;
        articleCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑add ng bagong article sa Charter
    function addArticle(string calldata title, string calldata content) external onlyGuardian {
        articleCount++;
        articles[articleCount] = Article(articleCount, title, content, true);
        emit ArticleAdded(articleCount, title);
    }

    /// @notice Mag‑update ng existing article
    function updateArticle(uint256 id, string calldata title, string calldata content) external onlyGuardian {
        Article storage a = articles[id];
        a.title = title;
        a.content = content;
        emit ArticleUpdated(id, title);
    }

    /// @notice Baguhin ang status ng article (active/inactive)
    function setArticleStatus(uint256 id, bool active) external onlyGuardian {
        articles[id].active = active;
        emit ArticleStatusChanged(id, active);
    }

    /// @notice Tingnan ang article details
    function viewArticle(uint256 id) external view returns (Article memory) {
        return articles[id];
    }
}
