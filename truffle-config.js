//const HDWalletProvider = require("truffle-hdwallet-provider-privkey");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const privateKeys = ["2528c751e8841324ad7f4b414c591cd05f1026154503d9872612247b1548552c"]; 

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
    testnet: {
      provider: () => new HDWalletProvider(privateKeys, `https://testnet.emerald.oasis.dev`),
      network_id: 42261,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    mainnet: {
      provider: () => new HDWalletProvider(privateKeys, `https://emerald.oasis.dev`),
      network_id: 42262,
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
