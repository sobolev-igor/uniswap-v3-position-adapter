require("@babel/register");
require("core-js");
require("regenerator-runtime/runtime");
require("dotenv").config();
import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-etherscan";
import "hardhat-gas-reporter";
import "hardhat-tracer";
import "hardhat-docgen";
import "solidity-coverage";


const config: HardhatUserConfig = {
  solidity: {
    version: "0.7.6",
    settings: {
      optimizer: {
        enabled: true,
        runs: 10000,
      },
    },
  },
  networks: {
    hardhat: {
      forking: {
        url: `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`,
      },
      blockGasLimit: 10000000,
      gas: 10000000,
      allowUnlimitedContractSize: true,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`,
      // accounts: [process.env.PRIVATE_KEY],
      gasPrice: 1 * 1000000000,
      gas: 1500000,
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      // accounts: [process.env.PRIVATE_KEY],
      gasPrice: 42 * 1000000000,
      gas: 1500000,
    },
  },
  // gasReporter: {
  //   currency: "USD",
  //   enabled: process.env.REPORT_GAS ? true : false,
  //   gasPrice: 100,
  // },
  docgen: {
    path: "./docs",
    clear: false,
    runOnCompile: false,
  },
  mocha: {
    timeout: "200000",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  }
};

export default config;
