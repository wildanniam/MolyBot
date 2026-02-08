# News Monitoring Skill

Monitor and track breaking news across industries with relevance filtering and structured summaries.

## Usage

```bash
cd /root/clawd/skills/news-monitoring

# Basic search
node scripts/news-monitor.js "Bitcoin price"

# With keywords
node scripts/news-monitor.js "AI machine learning startup" \
  --keywords "AI, startup, funding"
```

## Features

- Multi-source news aggregation
- Keyword-based relevance filtering
- Structured summary reports
- Timestamp tracking

