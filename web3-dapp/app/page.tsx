"use client";

import { useEffect, useState } from "react";
import { ethers } from "ethers";
import { ECOSYSTEM_CONTRACTS, RPC_URL } from "../lib/contracts/config";
import InstitutionalAuditHistoryArtifact from "../lib/contracts/InstitutionalAuditHistory.json";

interface ContractStatus {
  name: string;
  address: string;
  description: string;
  isActive: boolean | null;
}

export default function Home() {
  const [guardian, setGuardian] = useState<string>("Bumabasa...");
  const [contracts, setContracts] = useState<ContractStatus[]>(
    ECOSYSTEM_CONTRACTS.map(c => ({ ...c, isActive: null }))
  );
  
  // Wallet Connection States
  const [userAddress, setUserAddress] = useState<string | null>(null);
  const [isConnecting, setIsConnecting] = useState<boolean>(false);
  const [signer, setSigner] = useState<any>(null);

  // Admin Actions States
  const [targetLogger, setTargetLogger] = useState<string>("");
  const [authStatus, setAuthStatus] = useState<boolean>(true);
  const [txLoading, setTxLoading] = useState<boolean>(false);
  const [txMessage, setTxMessage] = useState<{ text: string; success: boolean } | null>(null);

  useEffect(() => {
    const provider = new ethers.JsonRpcProvider(RPC_URL);

    // 1. Basahin ang Guardian Address mula sa Core Contract
    async function fetchGuardian() {
      try {
        const coreContract = new ethers.Contract(
          ECOSYSTEM_CONTRACTS[0].address,
          InstitutionalAuditHistoryArtifact.abi,
          provider
        );
        const address = await coreContract.guardian();
        setGuardian(address);
      } catch (error) {
        console.error("Error fetching guardian:", error);
        setGuardian("Error loading.");
      }
    }

    // 2. I-verify ang bytecodes
    async function verifyContractBytecodes() {
      const updatedContracts = await Promise.all(
        ECOSYSTEM_CONTRACTS.map(async (c) => {
          try {
            const bytecode = await provider.getCode(c.address);
            const isActive = bytecode !== "0x" && bytecode !== "0x0";
            return { ...c, isActive };
          } catch (error) {
            console.error(`Error verifying ${c.name}:`, error);
            return { ...c, isActive: false };
          }
        })
      );
      setContracts(updatedContracts);
    }

    fetchGuardian();
    verifyContractBytecodes();

    // Makinig kung nagbago ang account sa MetaMask
    if (typeof window !== "undefined" && (window as any).ethereum) {
      (window as any).ethereum.on("accountsChanged", (accounts: string[]) => {
        if (accounts.length > 0) {
          setUserAddress(accounts[0]);
        } else {
          setUserAddress(null);
          setSigner(null);
        }
      });
    }
  }, []);

  // 3. Wallet Connection Logic
  const connectWallet = async () => {
    if (typeof window === "undefined" || !(window as any).ethereum) {
      alert("Please install MetaMask or another Web3 wallet to connect.");
      return;
    }
    
    setIsConnecting(true);
    try {
      const browserProvider = new ethers.BrowserProvider((window as any).ethereum);
      
      // I-request ang account access
      const accounts = await browserProvider.send("eth_requestAccounts", []);
      const currentSigner = await browserProvider.getSigner();
      
      setUserAddress(accounts[0]);
      setSigner(currentSigner);
    } catch (error) {
      console.error("Error connecting wallet:", error);
    } finally {
      setIsConnecting(false);
    }
  };

  // 4. Submit Transaction: setLoggerAuthorization
  const handleAuthorize = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!signer) return;
    if (!ethers.isAddress(targetLogger)) {
      setTxMessage({ text: "Invalid Ethereum Address format.", success: false });
      return;
    }

    setTxLoading(true);
    setTxMessage(null);

    try {
      // Gumawa ng contract instance gamit ang active Signer (User Wallet)
      const auditContract = new ethers.Contract(
        ECOSYSTEM_CONTRACTS[0].address,
        InstitutionalAuditHistoryArtifact.abi,
        signer
      );

      // I-trigger ang live on-chain transaction
      const tx = await auditContract.setLoggerAuthorization(targetLogger, authStatus);
      setTxMessage({ text: "Transaction submitted! Waiting for confirmation...", success: true });
      
      // Wait for block confirmation
      const receipt = await tx.wait();
      setTxMessage({ 
        text: `Success! Logger authorization updated in block ${receipt.blockNumber}. Tx Hash: ${tx.hash.substring(0, 16)}...`, 
        success: true 
      });
      setTargetLogger(""); // I-reset ang input field
    } catch (error: any) {
      console.error("Transaction failed:", error);
      const errorMsg = error.reason || error.message || "Transaction reverted on-chain.";
      setTxMessage({ text: `Failed: ${errorMsg}`, success: false });
    } finally {
      setTxLoading(false);
    }
  };

  const isUserGuardian = userAddress && guardian && userAddress.toLowerCase() === guardian.toLowerCase();

  return (
    <main className="flex min-h-screen flex-col items-center justify-start p-8 md:p-24 bg-gray-950 text-white font-sans">
      <div className="max-w-6xl w-full flex flex-col gap-10">
        
        {/* Header Section */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center border-b border-gray-800 pb-8 gap-4">
          <div>
            <h1 className="text-4xl font-extrabold text-emerald-400 tracking-tight">
              WIPO-ICA Safeguard Ecosystem
            </h1>
            <p className="text-gray-400 mt-2 text-sm">
              Live Network: <span className="text-emerald-500 font-semibold uppercase tracking-wider">Sepolia Testnet (Chain 11155111)</span>
            </p>
          </div>
          
          {/* Connection Button */}
          <div className="flex flex-col sm:flex-row gap-3 items-stretch sm:items-center w-full md:w-auto">
            {userAddress ? (
              <div className="bg-gray-900 border border-gray-800 px-5 py-2.5 rounded-lg flex flex-col gap-0.5">
                <span className="text-gray-500 font-bold uppercase tracking-widest text-[9px]">Connected Wallet</span>
                <span className="font-mono text-xs text-emerald-400 break-all select-all">
                  {userAddress.substring(0, 6)}...{userAddress.substring(userAddress.length - 4)}
                </span>
              </div>
            ) : (
              <button
                onClick={connectWallet}
                disabled={isConnecting}
                className="px-6 py-3 bg-emerald-500 hover:bg-emerald-600 active:scale-95 text-gray-950 font-bold rounded-lg transition-all duration-200 text-sm disabled:opacity-50"
              >
                {isConnecting ? "Connecting..." : "Connect Wallet"}
              </button>
            )}
          </div>
        </div>

        {/* Global Overview Panel */}
        <div className="bg-gray-900/50 border border-gray-800 p-6 rounded-xl flex flex-col md:flex-row gap-6 justify-between items-start md:items-center">
          <div>
            <h3 className="text-emerald-500 font-bold uppercase tracking-widest text-xs mb-1">Ecosystem Supreme Guardian</h3>
            <p className="font-mono text-sm text-gray-300 break-all">{guardian}</p>
          </div>
          {isUserGuardian && (
            <span className="bg-emerald-950 border border-emerald-500/30 text-emerald-400 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-wide">
              ⚡ Guardian Mode Active
            </span>
          )}
        </div>

        {/* Dynamic Guardian Admin Console */}
        {isUserGuardian ? (
          <div className="bg-gray-900 border border-emerald-500/20 p-6 rounded-xl flex flex-col gap-6 shadow-lg shadow-emerald-950/10">
            <div>
              <h2 className="text-xl font-bold text-gray-100 flex items-center gap-2">
                <span className="inline-block w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
                Guardian Telemetry Command Panel
              </h2>
              <p className="text-gray-400 text-xs mt-1">
                Ikaw ang nakarehistrong Supreme Guardian. May awtoridad kang pamahalaan ang telemetry logging privileges ng buong ecosystem.
              </p>
            </div>

            <form onSubmit={handleAuthorize} className="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
              <div className="flex flex-col gap-2">
                <label className="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Target Contract / Logger Address</label>
                <input 
                  type="text" 
                  value={targetLogger}
                  onChange={(e) => setTargetLogger(e.target.value)}
                  placeholder="0x..." 
                  required
                  className="bg-black border border-gray-800 rounded px-4 py-2.5 text-xs font-mono focus:border-emerald-500 outline-none text-gray-100"
                />
              </div>

              <div className="flex flex-col gap-2">
                <label className="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Clearance Authorization Status</label>
                <select 
                  value={authStatus ? "true" : "false"}
                  onChange={(e) => setAuthStatus(e.target.value === "true")}
                  className="bg-black border border-gray-800 rounded px-4 py-2.5 text-xs font-mono focus:border-emerald-500 outline-none text-gray-100"
                >
                  <option value="true">Authorize (TRUE)</option>
                  <option value="false">Revoke (FALSE)</option>
                </select>
              </div>

              <button
                type="submit"
                disabled={txLoading}
                className="bg-emerald-500 text-gray-950 hover:bg-emerald-600 active:scale-95 font-bold text-xs uppercase py-3 rounded tracking-wider transition-all disabled:opacity-50"
              >
                {txLoading ? "Executing Tx..." : "Broadcast Auth Change"}
              </button>
            </form>

            {txMessage && (
              <div className={`p-4 rounded text-xs font-mono border ${
                txMessage.success 
                  ? "bg-emerald-950/40 border-emerald-500/20 text-emerald-400" 
                  : "bg-red-950/40 border-red-500/20 text-red-400"
              }`}>
                {txMessage.text}
              </div>
            )}
          </div>
        ) : userAddress ? (
          <div className="bg-gray-900 border border-gray-800 p-6 rounded-xl text-center text-gray-400 text-xs">
            ⚠️ Connected wallet (<span className="text-gray-300 font-mono">{userAddress}</span>) is not authorized as the Supreme Guardian. Admin Panel locked.
          </div>
        ) : null}

        {/* Contracts Grid */}
        <div className="flex flex-col gap-4">
          <h2 className="text-xl font-bold tracking-tight text-gray-200">
            Deployed On-Chain Contracts Directory ({contracts.length})
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {contracts.map((c, index) => (
              <div 
                key={index}
                className="bg-gray-900 p-6 rounded-xl border border-gray-800 hover:border-emerald-500/30 transition-all duration-300 flex flex-col justify-between gap-4"
              >
                <div className="flex flex-col gap-2">
                  <div className="flex justify-between items-start gap-2">
                    <h3 className="font-bold text-gray-100 text-base leading-tight">
                      {c.name}
                    </h3>
                    
                    {c.isActive === null ? (
                      <span className="px-2.5 py-0.5 text-[10px] font-bold rounded bg-gray-800 text-gray-400 animate-pulse uppercase">
                        Checking
                      </span>
                    ) : c.isActive ? (
                      <span className="px-2.5 py-0.5 text-[10px] font-bold rounded bg-emerald-950/80 text-emerald-400 border border-emerald-500/20 uppercase tracking-wide">
                        Active
                      </span>
                    ) : (
                      <span className="px-2.5 py-0.5 text-[10px] font-bold rounded bg-red-950/85 text-red-400 border border-red-500/20 uppercase tracking-wide">
                        Inactive
                      </span>
                    )}
                  </div>
                  
                  <p className="text-gray-400 text-xs leading-relaxed">
                    {c.description}
                  </p>
                </div>

                <div className="bg-black/40 p-3 rounded border border-gray-800/80 flex flex-col gap-1">
                  <span className="text-[9px] text-gray-500 uppercase tracking-wider font-bold">
                    Contract Address
                  </span>
                  <a 
                    href={`https://sepolia.etherscan.io/address/${c.address}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="font-mono text-[10px] text-emerald-400/90 hover:text-emerald-400 break-all underline hover:no-underline transition-colors"
                  >
                    {c.address}
                  </a>
                </div>
              </div>
            ))}
          </div>
        </div>

      </div>
    </main>
  );
}
