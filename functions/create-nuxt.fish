function create-nuxt
    function NuxtConfig->JSON
        tr -d '\n' < nuxt.config.ts \
        | rg -P 'defineNuxtConfig\s*\(\s*\K\{.*\}(?=\s*\)\s*$)' -o \
        | xargs -0 node -e 'console.log(JSON.stringify(eval("(" + process.argv[1] + ")"), null, 2))' > tmp.config.json
    end

    function JSON->NuxtConfig
        node -e '
        const fs = require("fs");
        const target = process.argv[1];
        const repl   = fs.readFileSync("tmp.config.json","utf8");

        const m2 = repl.match(/\{[\s\S]*\}/);
        if (!m2) throw new Error("No {...} in test.js");
        const newBlock = m2[0];

        let src = fs.readFileSync(target,"utf8");

        let depth = 0, start = -1, end = -1;
        for (let i = 0; i < src.length; i++) {
          if (src[i] === "{") {
            if (depth++ === 0) start = i;
          } else if (src[i] === "}") {
            if (--depth === 0) { end = i + 1; break; }
          }
        }
        if (start === -1) throw new Error("No {...} in target file");

        src = src.slice(0, start) + newBlock + src.slice(end);
        fs.writeFileSync(target, src);
        console.log("Updated Nuxt Config", target);
        '  nuxt.config.ts
        rm tmp.config.json
    end

    read -P 'Project name: ' project_name
    # npx nuxi@latest init "$project_name"
    echo "debug"
    cd "$project_name"
    NuxtConfig->JSON
    # # use dasel to update tmp.config.json
    # dasel put -r json -f tmp.config.json 'css' -t json -v '["~/assets/css/main.css"]'
    # dasel put -r json -f tmp.config.json 'vite.plugins' -t json -v '["tailwindcss()"]'
    # printf 'import tailwindcss from "@tailwindcss/vite";\n' | cat - nuxt.config.ts | sponge nuxt.config.ts
    # JSON->NuxtConfig
    # # properly install tailwindcss
    # # will need control logic for npm, pnpm, yarn, bun & deno
    # pnpm add -D tailwindcss @tailwindcss/vite
    # # set up the /app folder
    # mkdir app/assets
    # mkdir app/assets/css
    # touch app/assets/css/main.css
    # printf '@import "tailwindcss";\n' | cat - app/assets/css/main.css | sponge app/assets/css/main.css
    echo "Tailwindcss added"
    # mkdir app/layouts
    # mkdir app/pages
    exec fish
end
