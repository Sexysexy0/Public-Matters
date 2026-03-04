pragma solidity ^0.8.0;

contract FundingSupportDAO {
    struct Support {
        uint256 id;
        string partner;
        uint256 amount;
        string purpose;
        bool released;
    }

    uint256 public supportCount;
    mapping(uint256 => Support) public supports;

    event SupportReleased(uint256 id, string partner, uint256 amount, string purpose);

    function releaseSupport(string memory partner, uint256 amount, string memory purpose) public {
        supportCount++;
        supports[supportCount] = Support(supportCount, partner, amount, purpose, true);
        emit SupportReleased(supportCount, partner, amount, purpose);
    }
}
