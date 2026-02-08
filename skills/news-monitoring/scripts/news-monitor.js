#!/usr/bin/env node

const { web_search } = require('@clawdbot/tools');

async function main() {
  const query = process.argv[2] || 'latest news';
  console.log(`🔍 Searching for: ${query}\n`);

  const results = await web_search({
    query: query,
    count: 5
  });

  results.forEach((item, i) => {
    console.log(`${i + 1}. **${item.title}**`);
    console.log(`   - ${item.url}`);
    console.log(`   - ${item.snippet}\n`);
  });

  console.log(`✅ Done! ${results.length} items found.`);
}

main().catch(console.error);
