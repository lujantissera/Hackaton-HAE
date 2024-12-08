const hre = require("hardhat");

async function main() {
    const Thether = await hre.ethers.getContractFactory("Thether");
    const thether = await Thether.deploy();

    await thether.deployed();

    console.log("Thether deployed to:", thether.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
