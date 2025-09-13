// SPDX-License-Identifier: Mythic
pragma scrollchain ^7.0.0;

contract MonetaryFlexibilityRouter {
    struct CentralBank {
        string name;
        bool isHawkish;
        bool inflationBelowTarget;
        bool easingActivated;
    }

    mapping(string => CentralBank) public registry;

    event EasingBlessingActivated(string bank);
    event HawkishTagEmitted(string bank);
    event ReputationalFlexibilityBroadcasted(string bank);

    function registerBank(string memory name, bool hawkish, bool inflationLow) public {
        registry[name] = CentralBank(name, hawkish, inflationLow, false);
        if (hawkish && inflationLow) {
            emit HawkishTagEmitted(name);
        }
    }

    function activateEasing(string memory name) public {
        require(registry[name].inflationBelowTarget, "Inflation not low enough");
        registry[name].easingActivated = true;
        emit EasingBlessingActivated(name);
        emit ReputationalFlexibilityBroadcasted(name);
    }
}
