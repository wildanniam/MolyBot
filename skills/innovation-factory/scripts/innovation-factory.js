#!/usr/bin/env node

const ideas = [
  { name: 'News Monitoring System', feasibility: 8, impact: 9, total: 17 },
  { name: 'Research Synthesis Tool', feasibility: 7, impact: 8, total: 15 },
  { name: 'Innovation Factory', feasibility: 7, impact: 8, total: 15 },
];

console.log('💡 Innovation Ideas:\n');
ideas.forEach((idea, i) => {
  console.log(`${i + 1}. **${idea.name}** (Score: ${idea.total}/20)`);
  console.log(`   - Feasibility: ${idea.feasibility}/10`);
  console.log(`   - Impact: ${idea.impact}/10\n`);
});

console.log('✅ Done! Top opportunities identified.');
