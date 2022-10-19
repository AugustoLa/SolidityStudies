const {network} = require("hardhat")
const {networkConfig} = require('../helper-hardhat-config')


const deployFundMe: any = async function (hre: any) {
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId: number = network.config.chainId!

    // se chainId é X use address Y
    // se chainId é Z use address V

    const ethUsdPriceFeedAddres = networkConfig[chainId]["ethUsdPriceFeed"]
    

    // o que acontece quando queremos alterar as CHAINS(block)
    // quando usarmos uma localhost ou hardhat network precisamos usar um MOCK

    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: [],
        log: true,
    })
}
