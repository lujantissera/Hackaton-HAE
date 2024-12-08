document.addEventListener('DOMContentLoaded', () => {
  console.log("DOM cargado correctamente.");

  const connectMetaMaskButton = document.getElementById('connect-metamask');
  const buyButtons = document.querySelectorAll('.buy-button');
  const modal = new bootstrap.Modal(document.getElementById('buyModal'));
  const productNameInput = document.getElementById('productName');
  const quantityInput = document.getElementById('quantity');
  const confirmPurchaseButton = document.getElementById('confirmPurchase');

  let selectedProduct = "";
  let userAccount = null; // Variable para almacenar la cuenta conectada

  // Conectar MetaMask
  connectMetaMaskButton.addEventListener('click', async () => {
      try {
          if (typeof window.ethereum !== 'undefined') {
              const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
              userAccount = accounts[0]; // Guardar la cuenta conectada
              connectMetaMaskButton.textContent = `Conectado: ${userAccount}`;
              console.log(`Cuenta conectada: ${userAccount}`);
          } else {
              alert('MetaMask no está instalado. Por favor, instálalo para continuar.');
          }
      } catch (error) {
          console.error('Error al conectar MetaMask:', error);
          alert('Error al conectar MetaMask.');
      }
  });

  // Manejar clic en los botones de compra
  buyButtons.forEach(button => {
      button.addEventListener('click', (event) => {
          if (!userAccount) {
              alert("Por favor, conecta MetaMask antes de realizar una compra.");
              return;
          }

          selectedProduct = event.target.dataset.product; // Obtener producto del atributo data-product
          productNameInput.value = selectedProduct; // Rellenar el nombre del producto en el modal
          quantityInput.value = ""; // Limpiar el campo de cantidad
          modal.show(); // Mostrar el modal
      });
  });

  // Confirmar compra
  confirmPurchaseButton.addEventListener('click', async () => {
      const quantity = quantityInput.value;

      if (!quantity || quantity <= 0) {
          alert("Por favor, ingresa una cantidad válida.");
          return;
      }

      try {
          const provider = new ethers.providers.Web3Provider(window.ethereum);
          const signer = provider.getSigner();

          const contractAddress = "0xTuDireccionDeContrato";
          const contractABI = [
              {
                  "inputs": [
                      { "internalType": "string", "name": "productName", "type": "string" },
                      { "internalType": "uint256", "name": "quantity", "type": "uint256" }
                  ],
                  "name": "buyProduct",
                  "outputs": [],
                  "stateMutability": "payable",
                  "type": "function"
              }
          ];

          const contract = new ethers.Contract(contractAddress, contractABI, signer);

          const transaction = await contract.buyProduct(selectedProduct, quantity, {
              value: ethers.utils.parseEther("0.01") // Ajusta el valor según corresponda
          });

          console.log(`Transacción enviada: ${transaction.hash}`);
          alert(`Compra confirmada:\nProducto: ${selectedProduct}\nCantidad: ${quantity}\nTransacción: ${transaction.hash}`);
          modal.hide();
      } catch (error) {
          console.error('Error al interactuar con el contrato:', error);
          alert('Error al procesar la compra. Verifica la consola.');
      }
  });
});
