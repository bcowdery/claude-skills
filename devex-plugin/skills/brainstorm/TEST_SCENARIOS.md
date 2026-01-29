# Brainstorm Skill Test Scenarios

## Testing Methodology

This document outlines test scenarios for validating the brainstorm skill. Each scenario should be tested by invoking the skill and verifying the expected behavior.

---

## Test Scenario 1: Basic Feature Design

**Trigger:**
User asks: "I need to add user authentication to my web app"

**Expected Behavior:**
1. Skill should ask clarifying questions:
   - Type of authentication
   - User base and scale
   - What needs protection
   - Current state
   - Constraints

2. Should explore requirements (functional and non-functional)

3. Should propose simple solution first (e.g., JWT-based auth)

4. Should discuss relevant patterns:
   - Strategy pattern for multiple auth methods
   - Dependency Injection for testability

5. Should create design document at `docs/design/authentication-design.md`

6. Design doc should include:
   - Architecture diagram (Mermaid)
   - Component breakdown
   - Patterns applied
   - Alternatives considered

**Pass Criteria:**
- ✅ No code is written
- ✅ Questions are asked before proposing solution
- ✅ YAGNI is applied (challenges over-engineering)
- ✅ Design document created with diagrams
- ✅ References consulted when discussing patterns/principles

---

## Test Scenario 2: Refactoring Existing System

**Trigger:**
User asks: "Our payment processing code is a mess, everything is in one giant PaymentService class. Help me redesign it."

**Expected Behavior:**
1. Should ask about current pain points:
   - What makes it messy?
   - What changes frequently?
   - What's hard to test?

2. Should identify God Object anti-pattern
   - Reference `references/anti-patterns.md`
   - Explain why it's problematic

3. Should apply SRP to extract responsibilities
   - Reference `references/solid-principles.md`
   - Propose separate classes for different concerns

4. Should create architecture diagram showing:
   - Separated components
   - Clear responsibilities
   - Reduced coupling

5. Should discuss trade-offs of refactoring approach

**Pass Criteria:**
- ✅ Anti-pattern recognized and explained
- ✅ SOLID principles applied appropriately
- ✅ Alternatives discussed with trade-offs
- ✅ Design document created
- ✅ References consulted

---

## Test Scenario 3: Pattern Application

**Trigger:**
User asks: "I have several payment methods (credit card, PayPal, crypto). How should I structure this?"

**Expected Behavior:**
1. Should ask about:
   - Current implementation
   - How often new payment methods are added
   - Differences between payment methods
   - Testing requirements

2. Should identify variation point (payment processing algorithm)

3. Should suggest Strategy pattern
   - Reference `references/design-patterns.md`
   - Explain intent and applicability
   - Show structure with diagram

4. Should apply OCP
   - New payment methods = new classes, no modifications
   - Reference `references/solid-principles.md`

5. Should show alternative approaches:
   - Factory pattern
   - Command pattern
   - Discuss why Strategy fits best

**Pass Criteria:**
- ✅ Pattern suggested appropriately (not forced)
- ✅ Trade-offs discussed
- ✅ OCP explained in context
- ✅ Class diagram shows pattern structure
- ✅ Multiple alternatives presented

---

## Test Scenario 4: Over-Engineering Check (YAGNI)

**Trigger:**
User asks: "I'm building a simple blog. Should I implement microservices, message queues, and caching from the start?"

**Expected Behavior:**
1. Should challenge the assumptions:
   - What's the expected traffic?
   - What's actually needed NOW?
   - What problems are being solved?

2. Should strongly apply YAGNI
   - Reference `references/other-principles.md`
   - Explain premature optimization anti-pattern
   - Push back on unnecessary complexity

3. Should propose simplest solution:
   - Monolithic app for blog
   - Add complexity when needed

4. Should explain when to add complexity:
   - Actual performance problems
   - Proven bottlenecks
   - Real scale requirements

**Pass Criteria:**
- ✅ Challenges over-engineering firmly but politely
- ✅ YAGNI applied rigorously
- ✅ Simplest solution proposed
- ✅ Clear criteria for when to add complexity
- ✅ Reference to principles consulted

---

## Test Scenario 5: Anti-Pattern Recognition

**Trigger:**
User asks: "I'm using my database as a message queue between services. Should I optimize the polling?"

**Expected Behavior:**
1. Should recognize "Database as IPC" anti-pattern
   - Reference `references/anti-patterns.md`
   - Explain why it's problematic

2. Should explain better alternatives:
   - Actual message queues (RabbitMQ, Kafka, etc.)
   - Pub/sub patterns
   - Proper IPC mechanisms

3. Should discuss trade-offs:
   - Migration effort vs. long-term benefits
   - Performance and scalability implications

4. Should NOT optimize the anti-pattern
   - Focus on fixing the underlying problem
   - Not making the wrong solution faster

**Pass Criteria:**
- ✅ Anti-pattern identified immediately
- ✅ Better alternatives suggested
- ✅ Explains why current approach fails
- ✅ References consulted
- ✅ Doesn't optimize the anti-pattern

---

## Test Scenario 6: Diagram Generation

**Trigger:**
User asks: "Show me how a shopping cart system should be structured"

**Expected Behavior:**
1. Should ask about requirements first

2. Should create multiple diagram types:
   - Architecture diagram (components and relationships)
   - Class diagram (key entities)
   - Workflow described in steps (NOT sequence diagram unless truly complex)

3. Diagrams should use Mermaid syntax:
   - graph TD for architecture
   - classDiagram for data model
   - Proper syntax and formatting

4. Should NOT overuse sequence diagrams
   - Most flows described in numbered steps
   - Sequence diagram only if truly complex interaction

**Pass Criteria:**
- ✅ Architecture diagram created with Mermaid
- ✅ Class diagram created with Mermaid
- ✅ Workflow described in steps (not sequence diagram)
- ✅ Diagrams are clear and well-labeled
- ✅ Sequence diagrams used sparingly

---

## Test Scenario 7: Collaborative Refinement

**Trigger:**
User proposes a solution: "I'm thinking of using Singleton pattern for my configuration manager"

**Expected Behavior:**
1. Should explore the reasoning:
   - Why Singleton?
   - What problem does it solve?
   - Are there alternatives?

2. Should reference Singleton pattern in `references/design-patterns.md`
   - Show trade-offs
   - Mention modern alternatives (dependency injection)
   - Discuss testability concerns

3. Should propose alternative if more appropriate:
   - Dependency injection
   - Simple module pattern
   - Configuration service

4. Should be collaborative, not prescriptive:
   - Acknowledge user's reasoning
   - Present options
   - Let user decide with full information

**Pass Criteria:**
- ✅ Questions user's reasoning (gently)
- ✅ Presents alternatives with trade-offs
- ✅ References pattern documentation
- ✅ Collaborative tone, not dictatorial
- ✅ Educates rather than just telling

---

## Test Scenario 8: Design Document Creation

**Trigger:**
After brainstorming session, user asks: "Can you create the design document?"

**Expected Behavior:**
1. Should ask about save location:
   - Suggest `docs/design/` convention
   - Ask for filename preference

2. Should use template from `assets/design-doc-template.md`

3. Should adapt template:
   - Remove sections that don't apply
   - Fill in relevant sections
   - Include diagrams created during brainstorming

4. Should include:
   - Problem statement
   - Requirements
   - Proposed solution with diagrams
   - Patterns and principles applied
   - Alternatives considered
   - Trade-offs
   - Implementation notes

**Pass Criteria:**
- ✅ Template used as base
- ✅ Adapted appropriately
- ✅ All relevant sections filled
- ✅ Diagrams included
- ✅ Saved to correct location
- ✅ Well-formatted markdown

---

## Integration Testing

### Test: Skill Invocation

**Command:** (Simulated user request in Claude)
"Help me design a caching layer for my API"

**Expected:**
- Skill activates based on description match
- Brainstorming process begins
- References available for consultation
- Assets available for template

### Test: Reference Consultation

During brainstorming, skill should:
1. Reference `design-patterns.md` when discussing patterns
2. Reference `solid-principles.md` when discussing design quality
3. Reference `other-principles.md` when discussing YAGNI, DRY, TDD
4. Reference `anti-patterns.md` when warning about pitfalls

**Validation:**
- Check that references are actually consulted (not just assumed knowledge)
- Verify specific sections are referenced when appropriate

### Test: Asset Usage

When creating design document:
1. Should use `assets/design-doc-template.md` as base
2. Should adapt template appropriately
3. Should preserve Mermaid diagram syntax examples

---

## Manual Test Checklist

For each scenario above:

- [ ] Skill invokes correctly based on user request
- [ ] Questions are asked before proposing solution
- [ ] YAGNI applied (challenges over-engineering)
- [ ] SOLID principles referenced when relevant
- [ ] Design patterns referenced when relevant
- [ ] Anti-patterns recognized and called out
- [ ] Alternatives presented with trade-offs
- [ ] Diagrams use correct Mermaid syntax
- [ ] Sequence diagrams used sparingly
- [ ] Design document created when requested
- [ ] Template used as base for design doc
- [ ] No code is written (only design discussion)
- [ ] Tone is collaborative, not prescriptive
- [ ] References consulted strategically

---

## Success Criteria

The skill passes testing if:

1. ✅ All 8 scenarios behave as expected
2. ✅ References are consulted appropriately
3. ✅ Design documents follow template structure
4. ✅ Diagrams use valid Mermaid syntax
5. ✅ YAGNI is applied rigorously
6. ✅ No code is written during brainstorming
7. ✅ Collaborative tone maintained
8. ✅ Principles and patterns referenced, not just assumed

---

## Known Limitations

Document any issues discovered during testing:

1. [To be filled during testing]
2. [To be filled during testing]

---

## Recommended Improvements

Based on testing, document improvements:

1. [To be filled during testing]
2. [To be filled during testing]
