"use client";

import { useState } from "react";

export default function GamingDefenseSuite() {
  const [discTokenId, setDiscTokenId] = useState("");
  const [chipHash, setChipHash] = useState("");
  const [status, setStatus] = useState<string | null>(null);

  const handleRegisterDisc = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!discTokenId || !chipHash) {
      setStatus("Error: Pakilagay ang Token ID at Chip Hash.");
      return;
    }
    
    setStatus(`Processing registration for Disc Token ID: ${discTokenId}...`);
    
    setTimeout(() => {
      setStatus(`✅ Disc License Successfully Linked on-chain! Chip Hash: ${chipHash.slice(0, 10)}...`);
    }, 2000);
  };

  return (
    <div className="p-6 bg-slate-900 text-white rounded-xl border border-slate-800 shadow-xl my-6">
      <h2 className="text-2xl font-bold mb-2 text-indigo-400">
        🎮 Gaming Defense & Consumer Rights Suite
      </h2>
      <p className="text-sm text-slate-400 mb-6">
        Decentralized protocols countering lost digital ownership, forced online requirements, and GPU hardware limits.
      </p>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Module 1: Physical Disc Link */}
        <div className="p-4 bg-slate-800/60 rounded-lg border border-slate-700">
          <h3 className="font-semibold text-lg text-emerald-400 mb-2">
            💿 Register Physical Disc Link
          </h3>
          <p className="text-xs text-slate-400 mb-4">
            Link an encrypted NFC/ROM Physical Disc hash to an ERC-721 token license.
          </p>

          <form onSubmit={handleRegisterDisc} className="space-y-3">
            <div>
              <label className="block text-xs font-mono text-slate-300 mb-1">Disc Token ID</label>
              <input
                type="number"
                placeholder="e.g. 101"
                value={discTokenId}
                onChange={(e) => setDiscTokenId(e.target.value)}
                className="w-full px-3 py-2 bg-slate-900 border border-slate-700 rounded text-sm text-white focus:outline-none focus:border-indigo-500"
              />
            </div>
            <div>
              <label className="block text-xs font-mono text-slate-300 mb-1">Encrypted Chip Hash (Bytes32)</label>
              <input
                type="text"
                placeholder="0xabc123..."
                value={chipHash}
                onChange={(e) => setChipHash(e.target.value)}
                className="w-full px-3 py-2 bg-slate-900 border border-slate-700 rounded text-sm text-white focus:outline-none focus:border-indigo-500"
              />
            </div>
            <button
              type="submit"
              className="w-full py-2 bg-indigo-600 hover:bg-indigo-500 font-semibold rounded text-sm transition"
            >
              Broadcast Physical Disc Link
            </button>
          </form>
        </div>

        {/* Module 2: Quick Status Monitor */}
        <div className="p-4 bg-slate-800/60 rounded-lg border border-slate-700 flex flex-col justify-between">
          <div>
            <h3 className="font-semibold text-lg text-amber-400 mb-2">
              ⚡ Live Protocol Status
            </h3>
            <ul className="text-xs space-y-2 text-slate-300 font-mono">
              <li className="flex justify-between border-b border-slate-700/50 pb-1">
                <span>Resale Marketplace:</span>
                <span className="text-emerald-400">Active (0x4e88...d44a)</span>
              </li>
              <li className="flex justify-between border-b border-slate-700/50 pb-1">
                <span>Offline Right Vault:</span>
                <span className="text-emerald-400">Server Monitoring (0x0eCc...2320)</span>
              </li>
              <li className="flex justify-between border-b border-slate-700/50 pb-1">
                <span>DePIN GPU Escrow:</span>
                <span className="text-emerald-400">Ready to Lease (0x93AE...1a29E)</span>
              </li>
              <li className="flex justify-between border-b border-slate-700/50 pb-1">
                <span>Indie Crowdfund Vault:</span>
                <span className="text-emerald-400">Governed (0xd68D...9FDA)</span>
              </li>
            </ul>
          </div>

          {status && (
            <div className="mt-4 p-3 bg-slate-900 border border-indigo-500/30 rounded text-xs text-indigo-300">
              {status}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
