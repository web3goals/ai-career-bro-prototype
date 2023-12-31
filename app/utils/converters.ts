import { BigNumber, ethers } from "ethers";

/**
 * Convert "ipfs://..." to "http://...".
 */
export function ipfsUriToHttpUri(ipfsUri?: string): string {
  if (!ipfsUri || !ipfsUri.startsWith("ipfs://")) {
    throw new Error(`Fail to converting IPFS URI to HTTP URI: ${ipfsUri}`);
  }
  return ipfsUri.replace("ipfs://", "https://w3s.link/ipfs/");
}

/**
 * Convert "0x4306D7a79265D2cb85Db0c5a55ea5F4f6F73C4B1" to "0x430...c4b1".
 */
export function addressToShortAddress(address: string): string {
  let shortAddress = address;
  if (address?.length > 10) {
    shortAddress = `${address.substring(0, 6)}...${address.substring(
      address.length - 4
    )}`;
  }
  return shortAddress?.toLowerCase();
}

/**
 * Convert string like "0x44EAe6f0C8E0714B8d8676eA803Dec04B492Ba16" to ethers address type.
 */
export function stringToAddress(string?: string): `0x${string}` | undefined {
  if (!string) {
    return undefined;
  }
  return ethers.utils.getAddress(string) as `0x${string}`;
}

/**
 * Convert timestamp like "1677628800" to date object.
 */
export function timestampToDate(
  timestamp: number | string | BigNumber | undefined
): Date | undefined {
  let date;
  if (typeof timestamp === "number") {
    date = new Date(timestamp * 1000);
  }
  if (typeof timestamp === "string") {
    date = new Date(Number(timestamp) * 1000);
  }
  if (timestamp instanceof BigNumber) {
    date = new Date(timestamp.toNumber() * 1000);
  }
  return date;
}
