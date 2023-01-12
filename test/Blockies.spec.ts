import { expect } from "chai"
import { ethers } from "hardhat"

const setup = async () => {
  const [wallet] = await ethers.getSigners()
  const Strings = await ethers.getContractFactory("contracts/blockies/Strings.sol:Strings")
  const strings = await Strings.deploy()
  const ImageMap = await ethers.getContractFactory("ImageMap")
  const imageMap = await ImageMap.deploy()
  const Color = await ethers.getContractFactory("Color")
  const color = await Color.deploy()
  const Random = await ethers.getContractFactory("Random", {
    libraries: {
      Color: color.address,
      Strings: strings.address,
    },
  })
  const random = await Random.deploy()
  const Svg = await ethers.getContractFactory("Svg", {
    libraries: {
      Strings: strings.address,
      ImageMap: imageMap.address,
      Random: random.address,
    },
  })
  const svg = await Svg.deploy()
  return { svg, wallet }
}

describe("Blockies", function () {
  describe("renderBlockie()", function () {
    it("Should return an SVG string", async function () {
      const { svg, wallet } = await setup()
      console.log("Address:", wallet.address)
      console.log(await svg.generateSvg(wallet.address))
    })
  })
})
