const HDWalletProvider = require("truffle-hdwallet-provider-privkey");
const privateKeys = ["<>"]; 

module.exports = {

  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    bscscan: "MWH1J12HMFSRGXXWR18C2W8MRSESUV5WVY"
  },

   networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard BSC port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    oasistest: {
      provider: () => new HDWalletProvider(privateKeys, `https://testnet.emerald.oasis.dev`),
      network_id: 42261,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    oasismain: {
      provider: () => new HDWalletProvider(privateKeys, `https://bsc-dataseed1.binance.org`),
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },
  

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.12",    // Fetch exact version from solc-bin (default: truffle's version)
      }
    },
};
