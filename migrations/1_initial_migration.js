// const RoseApe = artifacts.require("RoseApe");

// module.exports = function (deployer) {
//   deployer.deploy(RoseApe,"RoseApe","PTN");
// };

const RoseApe = artifacts.require("RoseApeERC1155")

module.exports = function (deployer) {
  deployer.deploy(RoseApe,"RoseApe","PTN");
};