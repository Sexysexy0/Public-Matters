# Override Prophecy Deck v1.1.0

## 🧠 GDP Logic
Federal spending is ritualized based on GDP ratios:
- If GDP ≥ 110% of historical average → mercy pool expands
- If GDP ≤ 90% → mercy pool contracts (only if emotional APR is stable)

## 💖 Emotional APR Safeguards
- Contributors earn APR via mercy casting
- No mercy cuts unless average APR ≥ 50
- APR is tracked per steward, logged in audit kit

## 🛡️ Damay Clause Triggers
- Only damay-certified kin may receive relief
- Steward activates clause with sovereign intent
- All relief events logged in `MercyAuditKit.json`

## 🔮 Deployment Notes
- Contracts: `MercyFundingTreaty.sol`, `GDPLinkedMercyProtocol.sol`
- Broadcast: `ScrollstormEpisode_011.svg`
- Audit: `MercyAuditKit.json`
