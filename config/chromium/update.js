const repo = "claudiodekker/ungoogled-chromium-macos";

const request = await fetch(
  `https://api.github.com/repos/${repo}/releases/latest`,
  {
    headers: {
      accept: " application/vnd.github+json",
      "X-GitHub-Api-Version": "2022-11-28",
    },
  },
);

if (!request.ok) {
  console.error(
    `Failed to fetch the latest release metadata for github:${repo}`,
  );
  Deno.exit(1);
}

const releaseMetadata = await request.json();

const version = releaseMetadata.name;

console.log(`Latest release: ${version}`);

for (const asset of releaseMetadata.assets) {
  console.log(`Asset: ${asset.name}`);

  const sha256Hash = await $("nix-prefetch-url", asset.browser_download_url);
  const sriHash = await $(
    "nix-hash",
    "--type",
    "sha256",
    "--to-sri",
    sha256Hash.trim(),
  );

  console.log(`  SRI: ${sriHash}`);
  console.log(`  SHA256: ${sha256Hash}`);
}

async function $(name, ...args) {
  const command = new Deno.Command(name, { args });

  const { code, stdout, stderr } = await command.output();

  if (code !== 0) {
    console.log(
      `${name}: exited ${code} with ${new TextDecoder().decode(stderr)}`,
    );
  }

  return new TextDecoder().decode(stdout);
}
