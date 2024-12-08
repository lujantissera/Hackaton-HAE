import { ethers } from "ethers";
const contractAddress = "0x6E5F66C2C7Ece8C0dd2791729C266c1c7292BAB0"; // Dirección del contrato
const contractABI = [
    // Copia aquí el ABI de tu contrato
];
function navigateTo(sectionId) {
    const section = document.getElementById(sectionId);
    if (section) {
        section.scrollIntoView({ behavior: 'smooth' });
    }
}

document.getElementById('connect-button').addEventListener('click', async (event) => {
  let account;
  let button = event.target;

  try {
    // Solicitar acceso a MetaMask y obtener la cuenta
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    account = accounts[0];
    console.log('Cuenta conectada:', account);
    button.textContent = `Conectado: ${account}`;

    // Mostrar balance de la cuenta
    const balanceResult = await ethereum.request({
      method: 'eth_getBalance',
      params: [account, 'latest'],
    });
    const wei = parseInt(balanceResult, 16);
    const balance = wei / 10 ** 18;
    console.log(balance + ' ETH');

    // Abrir la billetera MetaMask
    await ethereum.request({
      method: 'wallet_requestPermissions',
      params: [{ eth_accounts: {} }],
    });
    console.log('Billetera abierta');
  } catch (error) {
    console.error('Error:', error);
    alert('Error al conectar con MetaMask o abrir la billetera.');
  }
});


async function connectMetaMask() {
    if (typeof window.ethereum !== 'undefined') {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(contractAddress, contractABI, signer);

        console.log("MetaMask conectado");
        return contract;
    } else {
        alert("MetaMask no está instalado. Por favor, instálalo.");
    }
}
