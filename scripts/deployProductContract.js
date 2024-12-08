const hre = require("hardhat");

async function main() {
    const TokenizarProducto = await hre.ethers.getContractFactory("TokenizarProducto");
    const productContract = await TokenizarProducto.deploy();

    await productContract.deployed();

    console.log("TokenizarProducto deployed to:", productContract.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
