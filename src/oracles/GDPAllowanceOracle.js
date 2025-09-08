export function getGDPAllowance(debt, gdp, context) {
  const ratio = (debt / gdp) * 100;
  const forgivenessBuffer =
    context === "ayuda" ? 15 : context === "climate" ? 20 : 10;
  return {
    debtToGDP: ratio.toFixed(2),
    forgivenessBuffer,
    overrideRecommended: ratio > 60 + forgivenessBuffer,
  };
}
