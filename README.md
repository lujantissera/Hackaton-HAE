
# FinanWork

![Texto alternativo](https://github.com/lujantissera/Hackaton-HAE/blob/main/Gemini_Generated_Image_vol2gkvol2gkvol2.png?raw=true)

Plataforma de preventa de productos utilizando blockchain. Permite tokenizar productos y venderlos a través de contratos inteligentes. Los compradores adquieren tokens representativos y al momento de la entrega, estos se devuelven al productor. El sistema incluye contratos inteligentes diseñados para manejar preventa, compra y el intercambio de tokens de forma descentralizada.

# Pruebas:
**Validaciones y FrontEnd**:
* https://create-finanwork.surge.sh/
* https://buy-finanwork.surge.sh/
* https://usdt-finanwork.surge.sh/


# Demo:
https://www.loom.com/share/4c019198d9374076a1cb783d32b79d09?sid=6671ccc4-cc5a-487e-b341-6c8626ec64c9

# Desarrollo:

* **Tether.sol**: Provee tokens USDT en testnet (Arbitrum Sepolia), que permite disponer de fondos ilimitados en las cuentas de los clientes para usar la plataforma.

* **PresaleManager.sol**: Administra la pre-venta, tokeniza productos (IERC1155) agregando nombre, cantidad, precio y fecha de compromiso de finalización del producto.

* **NewPresaleOrder.sol**: Sustitución mejorada de tokenización, permite representar como NFT dentro de metamask (u otras wallets), permite agregar productos nuevos sin re-deploy, incluye validaciones para evitar errores, permite cancelar orden.

* **MarketPlace**: Página donde listamos productos disponibles, tienen botón compra, conecta contra MetaMask.

* **Pop-Up de compra**: Formulario con nombre y cantidad, permite interactuar con el SC.
***
**Dependencias**: Ether.js, Metamask, Bootstrap

**Estructura de archivos**: MarketPlace.html, script.js
***
# Flujo:
![Cliente](https://github.com/lujantissera/Hackaton-HAE/blob/main/interaccion_cliente.jpeg?raw=true)

![Vendedor](https://github.com/lujantissera/Hackaton-HAE/blob/main/interaccion_vendedor.jpeg?raw=true)

![Main](https://github.com/lujantissera/Hackaton-HAE/blob/main/proceso_final.jpeg?raw=true)

# Despliegues:
* **Implementación en la red de Arbitrum Sepolia con verificación pública del contrato**.
https://sepolia.arbiscan.io//address/0xE78F35c40618da80b02749bc86f675cDd3DCA4bA#code
https://sepolia.arbiscan.io//address/0x92031aB625F13Aa82e30a498697f544ecfDD06F3#code
https://sepolia.arbiscan.io//address/0x0aeb1f4Cc2850DA844807C91517535835F4eF5AC#code

* **RouteScan**:
https://testnet.routescan.io/address/0xE78F35c40618da80b02749bc86f675cDd3DCA4bA/contract/421614
https://testnet.routescan.io/address/0x92031aB625F13Aa82e30a498697f544ecfDD06F3/contract/421614
https://testnet.routescan.io/address/0xE78F35c40618da80b02749bc86f675cDd3DCA4bA/contract/421614
