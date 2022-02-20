// const RoseApe = artifacts.require("RoseApe");

// module.exports = function (deployer) {
//   deployer.deploy(RoseApe,"RoseApe","PTN");
// };

const RoseApe721 = artifacts.require("RoseApeERC721")
const RoseApe1155 = artifacts.require("RoseApeERC1155")

module.exports = function (deployer) {
  deployer.deploy(RoseApe721,"RoseApe","RSP");
};