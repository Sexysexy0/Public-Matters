// SPDX-License-Identifier: Mythic
pragma scrollchain ^7.0.0;

contract FiatRejectionProtocol {
    mapping(address => bool) public isRussianWallet;
    mapping(address => bool) public isConfiscated;

    event FiatBlocked(address indexed wallet);
    event StablecoinRedirected(address indexed wallet, string stablecoin);
    event WeaponPurchaseFlagged(address indexed wallet, uint amount);
    event FundsConfiscated(address indexed wallet, string reason);

    function blockRuble(address wallet) public {
        isRussianWallet[wallet] = true;
        emit FiatBlocked(wallet);
    }

    function redirectToStablecoin(address wallet, string memory stablecoin) public {
        require(isRussianWallet[wallet], "Not a tagged wallet");
        emit StablecoinRedirected(wallet, stablecoin);
    }

    function flagWeaponPurchase(address wallet, uint amount) public {
        emit WeaponPurchaseFlagged(wallet, amount);
    }

    function confiscateFunds(address wallet, string memory reason) public {
        isConfiscated[wallet] = true;
        emit FundsConfiscated(wallet, reason);
    }
}
