import globals from "globals";
import tseslint from "typescript-eslint";

export default [
    {
        ignores: ["/contracts/DomainRegistrar.sol", "/test/DomainRegistrar.test.ts"]
    },
    { files: ["**/*.js"], languageOptions: { sourceType: "script" } },
    { languageOptions: { globals: globals.browser } },
    ...tseslint.configs.recommended
];
