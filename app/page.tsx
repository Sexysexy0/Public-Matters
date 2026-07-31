"use client";

import { useState } from "react";

interface NodeDomain {
  id: string;
  name: string;
  status: "OPTIMAL" | "PENDING_SYNC" | "CRITICAL_GAP";
  leadAdvisor: string;
  activeObligations: number;
}

export default function ControlTowerDashboard() {
  const [domains] = useState<NodeDomain[]>([
    { id: "GOV", name: "Governance & Succession", status: "OPTIMAL", leadAdvisor: "Family Trust Board", activeObligations: 2 },
    { id: "TAX", name: "Tax Strategy & Structure", status: "PENDING_SYNC", leadAdvisor: "Cross-Border Tax Lead", activeObligations: 5 },
    { id: "LEG", name: "Legal & Entity Restructuring", status: "OPTIMAL", leadAdvisor: "General Counsel", activeObligations: 1 },
    { id: "INV", name: "Global Investments & Liquidity", status: "OPTIMAL", leadAdvisor: "CIO / Wealth Manager", activeObligations: 4 },
    { id: "REP", name: "Cross-Entity Reporting", status: "PENDING_SYNC", leadAdvisor: "Audit & Compliance", activeObligations: 3 },
    { id: "OBL", name: "Compliance & Filing Obligations", status: "CRITICAL_GAP", leadAdvisor: "Risk Office", activeObligations: 7 }
  ]);

  return (
    <main className="min-h-screen bg-slate-950 text-slate-100 p-8 max-w-7xl mx-auto">
      {/* Strategic Header */}
      <header className="mb-8 border-b border-slate-800 pb-6 flex justify-between items-end">
        <div>
          <div className="flex items-center gap-3 mb-2">
            <span className="px-3 py-1 bg-indigo-500/10 border border-indigo-500/30 text-indigo-400 text-xs font-mono font-bold rounded-full">
              CENTRAL CONTROL TOWER
            </span>
            <span className="text-xs font-mono text-slate-500">SYSTEM ID: CT-SVRGN-01</span>
          </div>
          <h1 className="text-3xl font-extrabold text-white tracking-tight">
            Strategic Coordination Infrastructure
          </h1>
          <p className="text-slate-400 text-sm mt-1">
            Bridging operational gaps between Tax, Governance, Legal, and Capital domains.
          </p>
        </div>
        
        <div className="text-right font-mono">
          <p className="text-xs text-slate-500">Cross-Domain Telemetry</p>
          <p className="text-emerald-400 font-bold text-sm">● ALL SYSTEMS LIVE</p>
        </div>
      </header>

      {/* Control Tower Architecture Visualization */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        {domains.map((domain) => (
          <div 
            key={domain.id} 
            className="p-5 bg-slate-900/80 rounded-xl border border-slate-800 hover:border-slate-700 transition flex flex-col justify-between"
          >
            <div>
              <div className="flex justify-between items-center mb-3">
                <span className="font-mono text-xs text-slate-400 bg-slate-800 px-2 py-1 rounded">
                  {domain.id}
                </span>
                <span className={`text-xs font-bold font-mono px-2 py-0.5 rounded ${
                  domain.status === "OPTIMAL" ? "bg-emerald-500/10 text-emerald-400 border border-emerald-500/20" :
                  domain.status === "PENDING_SYNC" ? "bg-amber-500/10 text-amber-400 border border-amber-500/20" :
                  "bg-rose-500/10 text-rose-400 border border-rose-500/20"
                }`}>
                  {domain.status}
                </span>
              </div>
              
              <h3 className="font-bold text-lg text-slate-100">{domain.name}</h3>
              <p className="text-xs text-slate-400 mt-1">Lead: {domain.leadAdvisor}</p>
            </div>

            <div className="mt-6 pt-4 border-t border-slate-800/80 flex justify-between items-center text-xs">
              <span className="text-slate-500">Active Dependencies</span>
              <span className="font-mono font-bold text-slate-200">{domain.activeObligations} Active</span>
            </div>
          </div>
        ))}
      </div>

      {/* Strategic AI Interlocking Logic */}
      <div className="p-6 bg-indigo-950/30 border border-indigo-500/20 rounded-xl">
        <h2 className="text-lg font-bold text-indigo-300 mb-2 flex items-center gap-2">
          ⚡ Cross-Domain Dependency Radar (AI Context Engine)
        </h2>
        <p className="text-xs text-slate-400 mb-4">
          Automated cross-referencing between isolated entities to ensure no legal, tax, or governance gaps remain undetected.
        </p>

        <div className="space-y-3 font-mono text-xs">
          <div className="p-3 bg-slate-900/90 rounded border border-slate-800 flex justify-between items-center">
            <span>[TAX ↔ LEG] Holding Entity restructuring flagged for potential trust distribution impact.</span>
            <span className="text-amber-400">Context Synced</span>
          </div>
          <div className="p-3 bg-slate-900/90 rounded border border-slate-800 flex justify-between items-center">
            <span>[INV ↔ GOV] Liquidity reallocation aligns with Q3 succession funding mandate.</span>
            <span className="text-emerald-400">Verified</span>
          </div>
        </div>
      </div>
    </main>
  );
}
