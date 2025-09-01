contract CommunityPotBuyback {
    UrbanBloomProtocol bloomProtocol;
    address public admin;
    uint256 public buybackRate = 0.02 ether;

    event PotVerified(address indexed gardener, uint256 count);
    event BlessingReleased(address indexed gardener, uint256 amount);

    constructor(address _bloomProtocol) {
        bloomProtocol = UrbanBloomProtocol(_bloomProtocol);
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not scroll-certified");
        _;
    }

    function verifyAndBuyback(address _gardener, uint256 _count) external onlyAdmin {
        UrbanBloomProtocol.Gardener memory g = bloomProtocol.getGardenerData(_gardener);
        require(g.isActive, "Not a gardener");

        uint256 reward = _count * buybackRate;
        payable(_gardener).transfer(reward);

        emit PotVerified(_gardener, _count);
        emit BlessingReleased(_gardener, reward);
    }

    function fundBuybacks() external payable onlyAdmin {}

    function updateBuybackRate(uint256 _newRate) external onlyAdmin {
        buybackRate = _newRate;
    }
}
