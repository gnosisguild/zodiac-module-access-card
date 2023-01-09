import { expect } from "chai"
import { ethers } from "hardhat"

const setup = async () => {
  const [wallet] = await ethers.getSigners()
  const Avatar = await ethers.getContractFactory("TestAvatar")
  const avatar = await Avatar.deploy()
  const AccessCard = await ethers.getContractFactory("AccessCard")
  const accessCard = await AccessCard.deploy()
  await accessCard.safeMint(wallet.address)
  return { avatar, accessCard, wallet }
}

describe("Access Card", function () {
  describe("Constructor", function () {
    it("Should initialize variables", async function () {
      const { accessCard } = await setup()
      expect(await accessCard.name()).to.equal("Zodiac Access Card")
      expect(await accessCard.symbol()).to.equal("CARD")
    })
  })
  describe("safeMint()", function () {
    it("Should let anyone mint an access card", async function () {
      const { avatar, accessCard } = await setup()
      const calldata = (await accessCard.populateTransaction.safeMint(avatar.address)).data
      if (!calldata) {
        throw new Error("no calldata")
      }
      expect(await avatar.exec(accessCard.address, 0, calldata))
      expect(await accessCard.ownerOf(1)).to.equal(avatar.address)
    })
  })
  describe("tokenURI()", function () {
    it("Returns baseURI with tokenId appended", async function () {
      const { accessCard } = await setup()
      expect(await accessCard.tokenURI(0)).to.equal("TODO: put in a URI/0")
    })
  })
})
