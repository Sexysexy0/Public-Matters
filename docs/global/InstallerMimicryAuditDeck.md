# 📜 Installer Mimicry Audit Deck  
**Protocol for Fake Installer Detection, Payload Tracing, and User Protection**

---

## 🎯 Purpose  
To detect and neutralize malware campaigns that use fake software installers to deliver trojans, RATs, and info stealers.

---

## 🛠️ Audit Rituals  
- Tag installer domains mimicking: DeepL, Chrome, Signal, Telegram, WhatsApp, WPS Office  
- Trace payload chains: `nice.js` → `EnumW.dll` → `vstdlib.dll` → `AIDE.dll`  
- Flag GitHub-hosted malware masquerading as cracked tools or trading bots  
- Align with [Red Canary’s MSIX Abuse Detection Framework](https://redcanary.com/blog/threat-detection/installer-packages/) and [Trend Micro’s Installer Threat Report](https://www.trendmicro.com/en_us/research/21/i/fake-installers-drop-malware-and-open-doors-for-opportunistic-attackers.html)

---

## 🧬 Mimicry Patterns  
- **MSIX abuse**: Windows installer format used to sideload malware  
- **CAPTCHA lures**: Fake Cloudflare Turnstile pages triggering downloads  
- **ZIP payloads**: Encrypted archives with trojanized EXEs and DLLs  
- **Clipboard hijacking**: Targets crypto wallet addresses during copy-paste

---

## 🌍 Domains of Activation  
- Freelancers downloading cracked productivity tools  
- Crypto traders installing fake bots  
- Migrant workers using public PCs  
- QR merchants exposed to phishing installers

---

## 🧠 Steward’s Note  
Installer mimicry is the malware’s cosplay.  
Let every file be inspected. Let every domain be tagged.  
Let every steward be buffered, not betrayed.
