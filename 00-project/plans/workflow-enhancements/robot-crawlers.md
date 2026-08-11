Here are the detailed Cloudflare WAF (Web Application Firewall) rules Nick Gray described in his post, based on what he listed as currently running on the Pro plan ($25/month). He presents them in priority order, with blocks first, then a skip for verified bots, followed by challenges and rate limiting.

1. Block China and Vietnam (by country)
Expression targets traffic from those countries (e.g., ip.src.country in {"CN"} or equal to "VN"; he also mentioned adding Singapore at one point).
Full block (no challenge). Zero latency impact for everyone else. Applied after a large Chinese botnet wave (3.6 million requests in one day from ~362k IPs).

2. Block 12 SEO crawlers by user-agent
Targets specific self-identifying bots such as SemrushBot, AhrefsBot, MJ12bot, DotBot, BLEXBot, Barkrowler, and others.
Example logic: lower(http.user_agent) contains "mj12bot" (and similar for the rest).
These repeatedly crawled all 1.5 million pages. He also blocks them in robots.txt.

3. Block AI crawlers with poor crawl-to-referral ratios by user-agent
Currently targets Claude-SearchBot (Anthropic) and Amzn-SearchBot (Amazon).
Allows them to still fetch /robots.txt so they know they are blocked:  
  (http.user_agent contains "Claude-SearchBot" or "Amzn-SearchBot") and uri.path ne "/robots.txt".
Claude-SearchBot was measured at 35,000 pages crawled per visitor referred; Amzn-SearchBot was hitting 117,000 pages/day with zero referrals.
Separate from Cloudflare’s built-in AI Crawl Control, which already blocks declared training bots (GPTBot, ClaudeBot, CCBot, Bytespider, etc.).

4. Skip everything below for verified bots
Uses Cloudflare’s cryptographic verification (cf.client.bot).
Applies to legitimate bots like Googlebot, Bingbot, and Applebot.
Placed after the block rules so any previously blocked “verified” bot stays blocked, but real search engines never get challenged.

5. Challenge every continent except North America
Managed Challenge (invisible CAPTCHA) for traffic from AF, AN, AS, OC, SA, EU, and Tor (T1).
Expression roughly: ip.src.continent in {"AF" "AN" "AS" "OC" "SA" "EU"} or similar, and not cf.client.bot.
His real audience is 97% North America (95.9% US + 1.3% Canada). Challenges are infrequent for legitimate users (one every 45 minutes).

6. Challenge empty user-agents
Targets requests where http.user_agent eq "" and not a verified bot.
Real browsers almost never send an empty User-Agent.

7. Challenge 46 datacenter ASNs
Challenges traffic from major cloud providers (AWS, Azure, and others; ASNs such as 14618, 16509, etc.).
Humans rarely browse from pure datacenter IPs (exceptions are VPNs or cloud desktops, which is why it’s a challenge rather than a hard block).
Added after waves of headless Chrome browsers running on AWS/Azure that polluted analytics.

8. Challenge stale browsers
Targets outdated User-Agents (Chrome versions 100–130 and older Firefox versions).
Exempts Firefox 115 ESR (still used by a tiny percentage of real users).
Aimed at frozen scraping toolkits that still identify as 2023-era browsers. Only ~0.54% of his real search traffic uses such old browsers.

9. Rate limit
30 page requests per 10 seconds per IP.
Applies only to paths without a file extension (i.e., HTML pages), and excludes verified bots:  
  http.request.uri.path.extension eq "" and not cf.client.bot.
Static assets are unaffected so normal page loads never trigger it.

Additional layers outside the numbered WAF rules
robots.txt**: Blocks the same SEO crawlers by name, plus many AI training bots (GPTBot, ClaudeBot, CCBot, Bytespider, Amazonbot, Google-Extended, etc.). It also includes Content-Signal headers (search=yes, ai-train=no, use=reference).
Cloudflare’s managed AI Crawl Control blocks declared training bots at the edge before his custom rules run.
He previously used (and then disabled) Cloudflare’s JavaScript Detections because of the performance hit (~2.8 seconds on mobile).

These rules are written in Cloudflare’s expression language and can be adapted to other WAFs. Gray notes that the CAPTCHA solve rate for the challenges is extremely low (~0.24%), indicating most bots simply abandon the attempt.