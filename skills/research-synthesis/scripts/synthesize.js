#!/usr/bin/env node

const { web_search } = require('@clawdbot/tools');

async function main() {
  const query = process.argv[2] || 'latest research';
  console.log('🔬 Synthesizing research...\n');

  const results = await web_search({
    query: query,
    count: 5
  });

  console.log(`📊 Summary: ${results.length} articles\n`);
  results.forEach((item, i) => {
    console.log(`${i + 1}. **${item.title}**`);
    console.log(`   - ${item.url}\n`);
  });
}

main().catch(console.error);
