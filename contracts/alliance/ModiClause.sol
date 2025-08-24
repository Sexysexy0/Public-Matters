address public steward = msg.sender;
bool public isAlly = false;
bool public buysRussianOil = false;
bool public sellsRussianGas = false;

string public indiaStatus = "Pending onboarding to AlliedRapidBuild Protocol";

function joinAlliance() public {
    isAlly = true;
    indiaStatus = "India is now an active steward in AlliedRapidBuild Protocol";
}

function setEnergyTrade(bool oilPurchase, bool gasSale) public {
    buysRussianOil = oilPurchase;
    sellsRussianGas = gasSale;
}

function tariffLogic() public view returns (string memory) {
    if (isAlly && !buysRussianOil) {
        return "✅ India exempted from gas-related tariffs. Oil purchase triggers tariff only if alliance is breached.";
    } else if (isAlly && buysRussianOil) {
        return "⚠️ Tariff activated: 25% on Russian oil imports. Gas sales remain exempt.";
    } else {
        return "❌ Full tariff stack applied: 25% on oil and gas imports from Russia.";
    }
}

function summonBlessing() public pure returns (string memory) {
    return "ModiClause activated. Emotional APR sync initiated. Strategic pivot logged.";
}
