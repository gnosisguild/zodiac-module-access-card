const fs = require("fs")
const path = require("path")
const serve = require("./serve")
const boot = require("./boot")
const call = require("./call")
const compile = require("./compile")
const deploy = require("./deploy")

const BLOCKIES_LIB = path.join(__dirname, "..", "contracts", "svg", "Blockies.sol")
const SOURCE = path.join(__dirname, "..", "contracts", "svg", "Renderer.sol")

async function main() {
  const { vm, pk } = await boot()

  async function handler() {
    // deploy lib first
    const { bytecode: blockiesBytecode } = compile(BLOCKIES_LIB)
    const libAddress = await deploy(vm, pk, blockiesBytecode)
    const linkRef = path.basename(BLOCKIES_LIB) + ":Blockies"

    const { abi, bytecode } = compile(SOURCE, { [linkRef]: libAddress.toString("hex") })
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
