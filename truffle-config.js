const HDWalletProvider = require("truffle-hdwallet-provider")

module.exports = {
  migrations_file_extension_regexp: /.*\.js$/,

  networks: {
    development: {
      host: "ganache", // hostname of the ganache network in the docker network
      port: 8545, // Standard Ethereum port (default: none)
      network_id: "*", // Any network (default: none)
      gasPrice: 1000000000,
      blockTime: 1,
    },

    ropsten: {
      provider: () =>
        new HDWalletProvider(process.env.MNEMONIC, process.env.ETHEREUM_PROVIDER_URL_ROPSTEN),
      from: process.env.DEPLOYMENT_ADDRESS,
      network_id: "3",
      gas: 1000000,
      gasPrice: 15000000000, // 15 GWei (in wei)
      skipDryRun: true, // Skip dry run before migrations? (default: false for public nets )
      confirmations: 1,    // # of confs to wait between deployments. (default: 0)
    },
  },

  compilers: {
    solc: {
      version: "0.5.16",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
        evmVersion: "istanbul",
      },
    }
  }
};
