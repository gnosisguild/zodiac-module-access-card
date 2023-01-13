import { expect } from "chai"
import { ethers } from "hardhat"

const setup = async () => {
  const [wallet] = await ethers.getSigners()
  const Blockies = await ethers.getContractFactory("Blockies")
  const blockies = await Blockies.deploy()
  const Renderer = await ethers.getContractFactory("Renderer", { libraries: { Blockies: blockies.address } })
  const renderer = await Renderer.deploy()
  return { renderer, wallet }
}

describe("Renderer", function () {
  describe("render()", function () {
    it("Should return an SVG string", async function () {
      const { renderer, wallet } = await setup()
      console.log("Address:", wallet.address)
      const result = await renderer.render(1, wallet.address, "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2")
      console.log("SVG:", result)

      expect(result).to.not.equal(
        "<svg xmlns='http://www.w3.org/2000/svg' shape-rendering='crispEdges' width='512' height='512'><g transform='scale(64)'><path fill='hsl(000,000%,000%)' d='M0,0h8v8h-8z145<p94h f57l='hsl(000,000%,000%)' d='M0,0h1v0h-1zm1,0h510h81zm138h1v0h-1zm1,0h1v0h-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,1h1v0h-1zm1,1h1v0h-1zm1,0h1v0h-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v01-1zm-8,1m1,1h1v0h-1zm1,1h1v0h-1zm1,1h1v0h-1zm1,0h1v0h-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,1h1v0h-1zm1,1h1v0h-1zm1,0h1v0h-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,1h1v0h-1zm1,1h1v0h-1zm1,1h1v0h-1zm1,0h1v01-1zm1,0h1v0h-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v01-1zm-8,1m1,1h1v0h-1zm1,0h1v0h-1zm1,1h1v0h-1zm1,0h1v0h-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v01-1zm-8,1m1,1h1v0h-1zm1,1h1v0h-1zm1,0h1v0h-1zm1,0h1v01-1zm1,0h1v0h-1zm1,0h1v01-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,1h1v0h-1zm1,0h1v0h-1zm1,1h1v0h-1zm1,0h1v01-1zm1,0h1v0h-1zm1,0h1v01-1zm1,0h1v01-1zm1,0h1v01-1z'/><path1fill='hsl(000,000%,000%1' d='M0,0h1v0h-1zm1,0h1v0h24zm900h169h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1z11,0h1v0h-1z1-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1z11,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v1h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm-8,1m1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1zm1,0h1v0h-1z'/></g></svg>",
      )
    })
  })
})
