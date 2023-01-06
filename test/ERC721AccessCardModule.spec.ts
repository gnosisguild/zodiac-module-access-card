import { expect } from "chai"
import { ethers } from "hardhat"

const setup = async () => {
  const [wallet] = await ethers.getSigners()
  const Avatar = await ethers.getContractFactory("TestAvatar")
  const avatar = await Avatar.deploy()
  const AccessCard = await ethers.getContractFactory("AccessCard")
  const accessCard = await AccessCard.deploy()
  await accessCard.safeMint(wallet.address)
  const Module = await ethers.getContractFactory("ERC721AccessCardModule")
  const ac = {
    tokenContract: accessCard.address,
    tokenId: 0,
  }
  const module = await Module.deploy(avatar.address, avatar.address, avatar.address, ac)
  await avatar.enableModule(module.address)
  const calldata = (await avatar.populateTransaction.enableModule(wallet.address)).data
  if (!calldata) {
    throw new Error("no calldata")
  }
  return { avatar, accessCard, module, Module, ac, wallet, calldata }
}

describe("ERC721AccessCardModule", function () {
  describe("Constructor", function () {
    it("Should initialize variables", async function () {
      const { avatar, module, ac } = await setup()
      expect(await module.owner()).to.equal(avatar.address)
      expect(await module.avatar()).to.equal(avatar.address)
      expect(await module.target()).to.equal(avatar.address)
      const accessCard = await module.accessCard()
      expect(accessCard.tokenContract).to.equal(ac.tokenContract)
      expect(accessCard.tokenId).to.equal(ac.tokenId)
    })
  })
  describe("executeTransaction()", function () {
    it("Should revert if msg.sender does not hold access card", async function () {
      const { avatar, calldata, accessCard, module, wallet } = await setup()
      await accessCard.transferFrom(wallet.address, avatar.address, 0)
      await expect(module.executeTransaction(avatar.address, 0, calldata, 0)).to.be.revertedWith("AccessDenied()")
    })
    it("Should execute transaction sent by access card holder", async function () {
      const { avatar, module, wallet, calldata } = await setup()
      await module.executeTransaction(avatar.address, 0, calldata, 0)
      expect(await avatar.module()).to.equal(wallet.address)
    })
  })
  describe("setAccessCard()", function () {
    it("Revert if called by account that is not owner", async function () {
      const { module, ac } = await setup()
      await expect(module.setAccessCard(ac)).to.be.revertedWith("Ownable: caller is not the owner")
    })
    it("Revert if access card is already set to this address and ID")
    it("Sets access card")
    it("Emits AccessCardSet() event")
  })
})
