---
name: news-monitoring
description: Monitor and track breaking news across industries. Fetch news from multiple sources, filter by relevance, and generate structured summaries with links and timestamps.
---

# News Monitoring

Monitor breaking news and track relevant stories across industries/tech/novelty. Fetch, filter, and summarize news automatically.

## When to Use

- Need to track breaking news in specific domain
- Want automated news aggregation with relevance filtering
- Research task requiring current information from multiple sources

## Core Workflow

1. **Define topic/filters**
   - Industry: tech, crypto, AI, health, environment, etc.
   - Keywords: specific terms to track
   - Region (optional): country/region specific news
   - Freshness: past 24h, week, month

2. **Fetch news**
   - Use `web_search` for general discovery
   - Use specific news sources (via URLs or search)
   - Target 5-10 high-quality sources

3. **Filter relevance**
   - Score stories by keyword match
   - Exclude irrelevant content
   - Prioritize breaking news (recent timestamps)

4. **Generate summary**
   - Extract key points per story
   - Identify patterns/connections
   - Note unique insights
   - Structure: Title | Source | Link | Summary | Timestamp

5. **Output format**
   - Markdown report with clear hierarchy
   - Table of contents for navigation
   - Direct links to source articles
   - Timestamp for each entry

## Tools

- `web_search` - discover news across web
- `web_fetch` - extract full content from specific articles
- Optional: `browser` for JS-heavy sites or login-protected content

## Example Query Structure

```bash
# General tech news
news-monitoring --topic tech --keywords AI ML startup --freshness 24h

# Crypto specific
news-monitoring --topic crypto --keywords Bitcoin regulation ETF --region US

# Innovation tracking
news-monitoring --topic innovation --keywords AI automation startup funding
```

## Output Structure

```markdown
# News Report: [Topic]

## Summary Overview
[Bullet point overview of key themes]

## Recent Stories

### [Story Title]
- **Source**: [URL]
- **Time**: [timestamp]
- **Key Points**:
  - Point 1
  - Point 2
  - Point 3
- **Tone**: [positive/negative/neutral]
- **Impact**: [high/medium/low]

### [Story Title]
...

## Themes & Patterns
[Identified trends across stories]

## Opportunities / Risks
[What this means for innovation]
```

## Tips for Quality

- Always verify timestamps are accurate
- Cross-reference with multiple sources when possible
- Note any conflicting information
- Highlight unique insights vs. common knowledge
- Keep summaries concise (1-2 sentences per point)
