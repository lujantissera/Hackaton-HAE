const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const GreeterModule = buildModule("thetherModule", (m) => {
  const greet = m.contract("thether", ["Hola"]);

  return { greet };
});

module.exports = GreeterModule;