export const metadata = {
  title: "Public Matters",
  description: "Governance and Compliance System"
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
