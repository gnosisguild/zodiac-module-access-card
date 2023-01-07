module.exports = {
  skipFiles: ["test/TestAvatar.sol", "test/TestERC1155Token"],
  mocha: {
    grep: "@skip-on-coverage", // Find everything with this tag
    invert: true, // Run the grep's inverse set.
  },
};
