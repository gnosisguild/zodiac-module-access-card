const fs = require("fs")
const path = require("path")
const serve = require("./serve")
const boot = require("./boot")
const call = require("./call")
const compile = require("./compile")
const deploy = require("./deploy")

const ZODIAC_BADGE_LIB = path.join(__dirname, "..", "contracts", "svg", "ZodiacBadge.sol")
const BLOCKIES_LIB = path.join(__dirname, "..", "contracts", "svg", "Blockies.sol")
const SOURCE = path.join(__dirname, "..", "contracts", "svg", "Renderer.sol")

async function main() {
  const { vm, pk } = await boot()

  async function handler() {
    // deploy lib first
    const { bytecode: zodiacBytecode } = compile(ZODIAC_BADGE_LIB)
    const zodiacLibAddress = await deploy(vm, pk, zodiacBytecode)
    const zodiacLinkRef = path.basename(ZODIAC_BADGE_LIB) + ":ZodiacBadge"

    const { bytecode: blockiesBytecode } = compile(BLOCKIES_LIB)
    const blockieLibAddress = await deploy(vm, pk, blockiesBytecode)
    const blockieLinkRef = path.basename(BLOCKIES_LIB) + ":Blockies"

    const { abi, bytecode } = compile(SOURCE, {
      [blockieLinkRef]: blockieLibAddress.toString("hex"),
      [zodiacLinkRef]: zodiacLibAddress.toString("hex"),
    })
    const address = await deploy(vm, pk, bytecode)
    const result = await call(vm, address, abi, "example")
    return result
  }

  const { notify } = await serve(handler)

  fs.watch(path.dirname(SOURCE), notify)
  console.log("Watching", path.dirname(SOURCE))
  console.log("Serving  http://localhost:9901/")
}

main()
