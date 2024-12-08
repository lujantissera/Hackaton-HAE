const hre = require("hardhat");

async function main() {
    // Direcciones del contrato de USDT y del contrato de productos (cambia estas direcciones por las reales)
    const usdtAddress = "0xdAC17F958D2ee523a2206206994597C13D831ec7"; // Dirección del contrato USDT en la red de prueba
    const productContractAddress = "0x..."; // Dirección del contrato de productos tokenizados

    // Obteniendo el contrato para desplegarlo
    const PresalePlatform = await hre.ethers.getContractFactory("PresalePlatform");

    // Desplegando el contrato con los parámetros necesarios
    const presalePlatform = await PresalePlatform.deploy(usdtAddress, productContractAddress);

    // Esperando a que el contrato sea desplegado
    await presalePlatform.deployed();

    console.log("PresalePlatform deployed to:", presalePlatform.address);
}

// Ejecutando la función principal y manejando errores
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
