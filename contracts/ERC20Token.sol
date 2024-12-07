// Contrato ERC-20 básico
contract ERC20Token is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialSupply, address owner) ERC20(name, symbol) {
        _mint(owner, initialSupply * (10 ** decimals()));
    }
}
