// const RoseApe = artifacts.require("RoseApe");

// module.exports = function (deployer) {
//   deployer.deploy(RoseApe,"RoseApe","PTN");
// };

const RoseApe721_V2 = artifacts.require("RoseApe721_V2")
//const RoseApe721 = artifacts.require("RoseApe721")
//const RoseApe1155 = artifacts.require("RoseApeERC1155")

module.exports = function (deployer) {
  //deployer.deploy(RoseApe721,"RoseApe","RSP");
  deployer.deploy(RoseApe721_V2,"TOKEN1","RPS1");
};