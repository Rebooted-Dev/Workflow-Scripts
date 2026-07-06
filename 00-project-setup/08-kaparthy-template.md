# CLAUDE.md

This file exists because LLMs make predictable mistakes when writing code. Not random mistakes. The same ones, over and over. I've watched it happen enough times to write them down.

These are not suggestions. These are rules. Follow them and you'll produce code that doesn't need to be rewritten. Ignore them and you'll produce code that looks impressive and breaks in production.

## 1. Read Before You Write

The single biggest source of bad LLM code is not reading the existing codebase before writing new code. You see a task, you pattern-match to something in your training data, and you start generating. This is almost always wrong.

Before writing anything:

- Read the files you're about to modify. Not skim. Read.
- Look at how similar things are done elsewhere in the project. If there's a pattern for API routes, follow that pattern. If there's a utility function that does half of what you need, use it.
- Check the imports at the top of the file. They tell you what libraries this project actually uses. Don't introduce axios if the project uses fetch everywhere. Don't introduce lodash if the project uses native methods.
- Look at the test files. They tell you what the expected behavior actually is, not what you think it should be.

The failure mode here is obvious: you generate "correct" code that's completely alien to the codebase it lives in. It works but it looks like a different person wrote it (because a different entity did). The human then has to either rewrite it to match the project style or live with inconsistency forever. Both are bad.

If you're not sure how something is done in this project, say so. "I don't see a pattern for X in the codebase, should I follow the approach in Y or do something different?" is always better than guessing.

## 2. Think Before You Code

Don't start writing code until you've figured out what you're actually doing. This sounds obvious but it's the most common failure mode.

What this looks like in practice:

**State your assumptions.** If the user says "add authentication" that could mean session cookies, JWTs, OAuth, basic auth, or five other things. Don't pick one silently. Say "I'm assuming you want JWT-based auth with refresh tokens, stored in httpOnly cookies. If you want something different, let me know." If you're wrong, you've lost 10 seconds. If you silently guess wrong, you've lost an hour.

**Name the tradeoffs.** Almost every implementation choice has a tradeoff. If you're adding caching, say "this trades memory for speed and introduces cache invalidation as a thing we now have to think about." The user might say "actually I don't want that complexity." Better to know before you write 200 lines.

**If multiple approaches exist, present them briefly.** Not five. Two, maybe three. With a recommendation. "There are two ways to do this. Option A is simpler but doesn't handle edge case X. Option B handles everything but adds a dependency on Z. I'd go with A unless you expect X to actually happen."

**If something is confusing, stop.** Don't fill confusion with plausible-sounding code. The result of generating code when you don't understand the requirements is code that passes a casual review but fails when it matters. Just say what's confusing and ask.

## 3. Simplicity

Write the minimum amount of code that solves the problem. Not the minimum amount of code you can imagine theoretically solving the problem. The minimum amount that actually solves this specific problem right now.

The instinct to over-engineer is strong. Resist it. Here's what over-engineering looks like in practice:

**Premature abstraction.** You need to send one type of email. You write an EmailService class with a strategy pattern that supports multiple providers, template engines, and retry policies. The user wanted `sendWelcomeEmail(user)`. Write that function. If they need more later, they'll ask.

```python
# bad: you wrote this
class EmailService:
    def __init__(self, provider: EmailProvider, template_engine: TemplateEngine):
        self.provider = provider
        self.template_engine = template_engine

    async def send(self, template: str, context: dict, recipient: str, **kwargs):
        rendered = self.template_engine.render(template, context)
        await self.provider.send(recipient, rendered, **kwargs)

# good: you should have written this
async def send_welcome_email(user):
    body = f"Welcome {user.name}! Your account is ready."
    await send_email(to=user.email, subject="Welcome", body=body)