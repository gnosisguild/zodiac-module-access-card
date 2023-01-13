import { expect } from "chai"
import { ethers } from "hardhat"

const setup = async () => {
  const [wallet] = await ethers.getSigners()
  const Blockies = await ethers.getContractFactory("Blockies")
  const blockies = await Blockies.deploy()
  return { blockies, wallet }
}

describe("Blockies", function () {
  describe("renderBlockie()", function () {
    it("Should return an SVG string", async function () {
      const { blockies, wallet } = await setup()
      console.log("Address:", wallet.address)
      console.log(await blockies.renderSVG(wallet.address))
    })
  })
})
