# Gang of Four Design Patterns Reference

This reference provides a comprehensive overview of the 23 Gang of Four (GoF) design patterns, organized by category. Use this to identify applicable patterns during architecture brainstorming sessions.

## Pattern Selection Guide

**How to choose a pattern:**
1. Identify the design problem (creation, structure, or behavior)
2. Consider the forces at play (flexibility, coupling, complexity)
3. Match problem characteristics to pattern intent
4. Evaluate trade-offs against project constraints

**When NOT to use patterns:**
- The problem is simple and doesn't need abstraction
- The pattern adds more complexity than it solves
- YAGNI applies - you don't need the flexibility yet
- The codebase is too small to benefit from the structure

---

## Creational Patterns

Patterns for object creation mechanisms, increasing flexibility and reuse.

### Abstract Factory

**Intent:** Provide interface for creating families of related objects without specifying concrete classes.

**When to use:**
- System needs to be independent of how objects are created
- System should work with multiple families of related products
- Family of related products must be used together
- Want to reveal only interfaces, not implementations

**Structure:** Factory interface → Concrete factories → Product families

**Trade-offs:**
- ✅ Isolates concrete classes
- ✅ Easy to exchange product families
- ✅ Promotes consistency among products
- ❌ Hard to add new product types (requires changing interface)
- ❌ Increased complexity with many product types

**Common mistakes:**
- Using when only one product family exists
- Not considering if Simple Factory or Factory Method suffices

---

### Builder

**Intent:** Separate construction of complex object from its representation.

**When to use:**
- Algorithm for creating object should be independent of parts and assembly
- Construction process must allow different representations
- Object has many optional parameters (telescoping constructor problem)
- Want to construct objects step-by-step

**Structure:** Director → Builder interface → Concrete builders → Product

**Trade-offs:**
- ✅ Vary product's internal representation
- ✅ Isolates code for construction and representation
- ✅ Finer control over construction process
- ✅ Eliminates telescoping constructors
- ❌ Requires creating separate builder for each product type
- ❌ May be overkill for simple objects

**Common mistakes:**
- Using for objects with few configuration options
- Not providing a fluent interface for step chaining
- Coupling builder too tightly to product structure

---

### Factory Method

**Intent:** Define interface for creating object, but let subclasses decide which class to instantiate.

**When to use:**
- Class can't anticipate the class of objects it must create
- Class wants subclasses to specify objects it creates
- Classes delegate responsibility to helper subclasses
- Need localized control over object creation

**Structure:** Creator (abstract) → Concrete creators → Product interface → Concrete products

**Trade-offs:**
- ✅ Eliminates binding to specific application classes
- ✅ Provides hooks for subclasses
- ✅ Connects parallel class hierarchies
- ❌ Clients might have to subclass just to create particular product
- ❌ Can lead to proliferation of creator subclasses

**Common mistakes:**
- Using when Simple Factory or dependency injection suffices
- Making factory method static (eliminates subclass override ability)

---

### Prototype

**Intent:** Specify kinds of objects to create using prototypical instance, create new objects by copying.

**When to use:**
- System should be independent of how products are created
- Classes to instantiate are specified at runtime
- Avoid building class hierarchy of factories parallel to products
- Instances of class can have limited combinations of state

**Structure:** Prototype interface (clone) → Concrete prototypes

**Trade-offs:**
- ✅ Add/remove products at runtime
- ✅ Specify new objects by varying values
- ✅ Reduced subclassing
- ✅ Configure application with classes dynamically
- ❌ Each subclass must implement clone
- ❌ Deep copy can be complex with circular references

**Common mistakes:**
- Not implementing deep copy when needed
- Using when object creation isn't the bottleneck
- Forgetting to handle mutable state properly

---

### Singleton

**Intent:** Ensure class has only one instance and provide global access point.

**When to use:**
- There must be exactly one instance of a class
- Instance must be accessible from well-known access point
- Sole instance should be extensible by subclassing

**Structure:** Private constructor → Static instance → Static access method

**Trade-offs:**
- ✅ Controlled access to sole instance
- ✅ Reduced namespace pollution
- ✅ Permits refinement of operations through subclassing
- ✅ Lazy initialization possible
- ❌ Global state (violates many design principles)
- ❌ Hard to unit test
- ❌ Thread-safety concerns
- ❌ Often sign of poor design (dependency injection preferred)

**Common mistakes:**
- Using for convenience rather than true single-instance requirement
- Not considering thread safety in concurrent environments
- Creating "god objects" that do too much
- Using instead of dependency injection

**Modern alternatives:** Dependency injection, service locator, module pattern

---

## Structural Patterns

Patterns for composing classes and objects into larger structures.

### Adapter

**Intent:** Convert interface of class into another interface clients expect. Let classes work together that couldn't otherwise due to incompatible interfaces.

**When to use:**
- Want to use existing class but interface doesn't match needs
- Want to create reusable class that cooperates with unrelated classes
- Need to use several existing subclasses but impractical to adapt by subclassing

**Structure:** Target interface → Adapter → Adaptee (existing class)

**Trade-offs:**
- ✅ Single Responsibility (separate interface conversion)
- ✅ Open/Closed (introduce new adapters without breaking existing code)
- ✅ Can work with legacy code
- ❌ Overall complexity increases
- ❌ Sometimes simpler to change service class directly

**Common mistakes:**
- Over-adapting when you could modify the original
- Creating adapters for interfaces that are unlikely to change

---

### Bridge

**Intent:** Decouple abstraction from implementation so both can vary independently.

**When to use:**
- Want to avoid permanent binding between abstraction and implementation
- Both abstractions and implementations should be extensible by subclassing
- Changes in implementation shouldn't impact clients
- Want to share implementation among multiple objects

**Structure:** Abstraction → Refined abstraction | Implementor → Concrete implementors

**Trade-offs:**
- ✅ Decouples interface and implementation
- ✅ Improved extensibility
- ✅ Hide implementation details from clients
- ❌ Added complexity
- ❌ Can be overkill for simple hierarchies

**Common mistakes:**
- Using when abstraction and implementation won't vary independently
- Confusing with Adapter (Bridge designs up-front, Adapter retrofits)

---

### Composite

**Intent:** Compose objects into tree structures to represent part-whole hierarchies. Let clients treat individual objects and compositions uniformly.

**When to use:**
- Want to represent part-whole hierarchies
- Want clients to ignore difference between compositions and individual objects
- Structure can be represented as a tree

**Structure:** Component interface → Leaf & Composite (contains Components)

**Trade-offs:**
- ✅ Defines hierarchies of primitive and composite objects
- ✅ Makes client simple (uniform treatment)
- ✅ Easy to add new component types
- ❌ Can make design overly general
- ❌ Hard to restrict component types in composite

**Common mistakes:**
- Using when objects don't naturally form a hierarchy
- Not handling parent references properly
- Overusing for flat collections

---

### Decorator

**Intent:** Attach additional responsibilities to object dynamically. Provide flexible alternative to subclassing for extending functionality.

**When to use:**
- Add responsibilities to individual objects dynamically and transparently
- Responsibilities can be withdrawn
- Extension by subclassing is impractical (would produce explosion of subclasses)
- Want to add features to objects without affecting other objects

**Structure:** Component interface → Concrete component & Decorator → Concrete decorators

**Trade-offs:**
- ✅ More flexibility than static inheritance
- ✅ Avoids feature-laden classes high in hierarchy
- ✅ Can add/remove responsibilities at runtime
- ❌ Decorator and component aren't identical
- ❌ Lots of little objects (hard to learn and debug)
- ❌ Order of decoration matters

**Common mistakes:**
- Using when simple inheritance would suffice
- Not maintaining component interface in decorator
- Creating decorators that depend on decoration order

---

### Facade

**Intent:** Provide unified interface to set of interfaces in subsystem. Define higher-level interface that makes subsystem easier to use.

**When to use:**
- Want to provide simple interface to complex subsystem
- Many dependencies between clients and implementation classes
- Want to layer subsystems (facade as entry point to each level)

**Structure:** Facade → Subsystem classes

**Trade-offs:**
- ✅ Shields clients from subsystem components
- ✅ Promotes weak coupling
- ✅ Easier to use and understand
- ✅ Doesn't prevent access to subsystem if needed
- ❌ Facade can become god object coupled to all classes
- ❌ Can hide too much, making debugging harder

**Common mistakes:**
- Making facade do too much (violates SRP)
- Using when clients need fine-grained control
- Creating dependencies from subsystem back to facade

---

### Flyweight

**Intent:** Use sharing to support large numbers of fine-grained objects efficiently.

**When to use:**
- Application uses large number of objects
- Storage costs are high due to quantity
- Most object state can be made extrinsic
- Many groups of objects can be replaced by few shared objects
- Application doesn't depend on object identity

**Structure:** Flyweight interface → Shared flyweights & Unshared flyweights → Flyweight factory

**Trade-offs:**
- ✅ Reduces memory consumption
- ✅ Can reduce total number of objects
- ❌ Increased complexity
- ❌ Runtime costs for transferring extrinsic state
- ❌ Can be confusing to maintain

**Common mistakes:**
- Using when few objects exist
- Not properly separating intrinsic/extrinsic state
- Forgetting thread safety for shared objects

---

### Proxy

**Intent:** Provide surrogate or placeholder for another object to control access to it.

**When to use:**
- Need more sophisticated reference than pointer
- Remote proxy (different address space)
- Virtual proxy (lazy initialization of expensive object)
- Protection proxy (access control)
- Smart reference (additional actions when accessing object)

**Structure:** Subject interface → Real subject & Proxy

**Trade-offs:**
- ✅ Controls access to object
- ✅ Additional functionality without changing object
- ✅ Transparent to client
- ❌ Response time might increase
- ❌ Added complexity
- ❌ Can make code harder to understand

**Common mistakes:**
- Using when direct access would suffice
- Not maintaining same interface as real subject
- Creating proxies that do too much

---

## Behavioral Patterns

Patterns concerned with algorithms and assignment of responsibilities between objects.

### Chain of Responsibility

**Intent:** Avoid coupling sender of request to receiver by giving multiple objects a chance to handle request. Chain receiving objects and pass request along chain until object handles it.

**When to use:**
- More than one object may handle request, handler not known a priori
- Want to issue request without specifying receiver explicitly
- Set of objects that can handle request should be specified dynamically

**Structure:** Handler interface (successor link) → Concrete handlers

**Trade-offs:**
- ✅ Reduced coupling
- ✅ Added flexibility in assigning responsibilities
- ✅ Easy to add new handlers
- ❌ Receipt not guaranteed
- ❌ Can be hard to observe runtime characteristics
- ❌ Debugging can be difficult

**Common mistakes:**
- Not having a default handler at end of chain
- Creating circular chains
- Using when single handler is always appropriate

---

### Command

**Intent:** Encapsulate request as object, letting you parameterize clients with different requests, queue or log requests, and support undoable operations.

**When to use:**
- Parameterize objects by action to perform
- Specify, queue, and execute requests at different times
- Support undo/redo
- Support logging changes
- Structure system around high-level operations built on primitives

**Structure:** Command interface (execute) → Concrete commands → Receiver → Invoker

**Trade-offs:**
- ✅ Decouples invoker from receiver
- ✅ Commands are first-class objects
- ✅ Can assemble commands into composite
- ✅ Easy to add new commands
- ✅ Supports undo/redo
- ❌ Increased number of classes
- ❌ Can be overkill for simple operations

**Common mistakes:**
- Using when simple callback would suffice
- Not implementing undo properly
- Creating commands that are too granular or too coarse

---

### Interpreter

**Intent:** Given language, define representation for its grammar along with interpreter that uses representation to interpret sentences.

**When to use:**
- Grammar is simple
- Efficiency is not critical concern
- Want to represent and evaluate expressions or rules

**Structure:** Abstract expression → Terminal & Nonterminal expressions → Context

**Trade-offs:**
- ✅ Easy to change and extend grammar
- ✅ Easy to implement grammar
- ❌ Complex grammars are hard to maintain
- ❌ Performance issues with large/complex grammars
- ❌ Many classes for complex grammar

**Common mistakes:**
- Using for complex grammars (parser generator better)
- Not caching/optimizing expression trees
- Using when simpler evaluation methods exist

**Modern alternatives:** Parser generators, DSL libraries, expression evaluators

---

### Iterator

**Intent:** Provide way to access elements of aggregate object sequentially without exposing underlying representation.

**When to use:**
- Access aggregate's contents without exposing internal structure
- Support multiple traversals of aggregate
- Provide uniform interface for traversing different structures

**Structure:** Iterator interface → Concrete iterators → Aggregate interface → Concrete aggregates

**Trade-offs:**
- ✅ Supports variations in traversal
- ✅ Simplifies aggregate interface
- ✅ Multiple simultaneous traversals possible
- ❌ Can be overkill if aggregate is simple
- ❌ Language might provide built-in iteration

**Common mistakes:**
- Implementing when language provides iteration primitives
- Not handling concurrent modification
- Creating iterators that maintain too much state

**Modern alternatives:** Built-in iterators, generators, streams

---

### Mediator

**Intent:** Define object that encapsulates how set of objects interact. Promotes loose coupling by keeping objects from referring to each other explicitly.

**When to use:**
- Set of objects communicate in well-defined but complex ways
- Reusing object is difficult because it refers to many other objects
- Behavior distributed between several classes should be customizable without subclassing

**Structure:** Mediator interface → Concrete mediator → Colleague objects

**Trade-offs:**
- ✅ Decouples colleagues
- ✅ Simplifies object protocols
- ✅ Centralizes control
- ✅ Abstracts object cooperation
- ❌ Mediator can become god object
- ❌ Can be overkill for simple interactions

**Common mistakes:**
- Creating mediators that do too much (violates SRP)
- Using for simple two-way communication
- Not defining clear colleague interfaces

---

### Memento

**Intent:** Without violating encapsulation, capture and externalize object's internal state so object can be restored to this state later.

**When to use:**
- Must save snapshot of object's state for later restoration
- Direct interface to obtain state would expose implementation details

**Structure:** Originator → Memento (opaque to all except originator) → Caretaker

**Trade-offs:**
- ✅ Preserves encapsulation boundaries
- ✅ Simplifies originator
- ❌ Expensive if originator must copy large amounts of data
- ❌ Hidden costs in caretaker (must track mementos)
- ❌ Can be difficult to ensure memento immutability

**Common mistakes:**
- Not considering memory costs
- Allowing direct access to memento internals
- Using when simpler state management exists

---

### Observer

**Intent:** Define one-to-many dependency between objects so when one changes state, all dependents are notified and updated automatically.

**When to use:**
- Abstraction has two aspects, one dependent on other
- Change to one object requires changing others, don't know how many
- Object should notify others without assumptions about who they are

**Structure:** Subject interface (attach/detach/notify) → Concrete subject → Observer interface (update) → Concrete observers

**Trade-offs:**
- ✅ Abstract coupling between subject and observer
- ✅ Support for broadcast communication
- ✅ Dynamic relationships (runtime)
- ❌ Unexpected updates
- ❌ Observer doesn't know about other observers (cascade effects)
- ❌ Memory leaks if observers not properly detached

**Common mistakes:**
- Not detaching observers (memory leaks)
- Creating observer notification cycles
- Not considering order of notifications
- Using when simple callbacks suffice

**Modern alternatives:** Reactive programming, event buses, pub/sub systems

---

### State

**Intent:** Allow object to alter behavior when internal state changes. Object will appear to change its class.

**When to use:**
- Object's behavior depends on state and must change at runtime
- Operations have large multipart conditional statements depending on state

**Structure:** Context → State interface → Concrete states

**Trade-offs:**
- ✅ Localizes state-specific behavior
- ✅ Makes state transitions explicit
- ✅ State objects can be shared
- ✅ Eliminates large conditionals
- ❌ Increases number of classes
- ❌ Can be overkill for simple state machines

**Common mistakes:**
- Using when simple if/else would suffice
- Not properly managing state transitions
- Creating states with too much shared logic

---

### Strategy

**Intent:** Define family of algorithms, encapsulate each one, and make them interchangeable. Lets algorithm vary independently from clients.

**When to use:**
- Many related classes differ only in behavior
- Need different variants of algorithm
- Algorithm uses data clients shouldn't know about
- Class has large conditional statement for selecting behavior

**Structure:** Context → Strategy interface → Concrete strategies

**Trade-offs:**
- ✅ Families of related algorithms
- ✅ Alternative to subclassing
- ✅ Eliminates conditional statements
- ✅ Choice of implementations
- ❌ Clients must understand different strategies
- ❌ Communication overhead between strategy and context
- ❌ Increased number of objects

**Common mistakes:**
- Using when behavior never changes
- Not considering if simple function/lambda would suffice
- Creating too many strategies for similar algorithms

---

### Template Method

**Intent:** Define skeleton of algorithm in operation, deferring some steps to subclasses. Lets subclasses redefine certain steps without changing algorithm structure.

**When to use:**
- Implement invariant parts of algorithm once, let subclasses implement varying behavior
- Control subclass extensions (hooks)
- Common behavior among subclasses should be factored and localized

**Structure:** Abstract class (template method + primitive operations) → Concrete classes

**Trade-offs:**
- ✅ Code reuse
- ✅ Controls extension points
- ✅ Inverted control structure ("Hollywood principle")
- ❌ Requires subclassing
- ❌ Can be constraining
- ❌ Violates Liskov Substitution if not careful

**Common mistakes:**
- Making too many methods overrideable
- Not clearly distinguishing required vs. optional hooks
- Using when composition would be more flexible

**Modern alternatives:** Composition with strategy pattern, functional approach with callbacks

---

### Visitor

**Intent:** Represent operation to be performed on elements of object structure. Lets define new operation without changing classes of elements on which it operates.

**When to use:**
- Object structure contains many classes with differing interfaces, want to perform operations that depend on concrete classes
- Many distinct operations need to be performed, don't want to pollute classes
- Classes defining object structure rarely change but often need new operations

**Structure:** Visitor interface → Concrete visitors | Element interface (accept) → Concrete elements

**Trade-offs:**
- ✅ Easy to add new operations
- ✅ Gathers related operations
- ✅ Visitor can accumulate state
- ❌ Hard to add new element classes
- ❌ Breaks encapsulation
- ❌ Circular dependency between visitor and elements

**Common mistakes:**
- Using when element classes change frequently
- Not considering double dispatch implications
- Creating visitors that do too many unrelated things

---

## Pattern Relationships and Selection

### Pattern Relationships

- **Abstract Factory** often implemented with **Factory Methods**
- **Abstract Factory**, **Builder**, **Prototype** are mutually exclusive creation approaches
- **Adapter** makes things work after design; **Bridge** makes them work before
- **Composite** often uses **Chain of Responsibility** for parent links
- **Decorator** changes object skin; **Strategy** changes object guts
- **Facade** simplifies interface; **Adapter** makes one interface look like another
- **Flyweight** explains when and how **State** and **Strategy** objects can be shared
- **Mediator** and **Observer** are competing patterns (Mediator distributes via mediator object, Observer via subject)
- **Proxy** and **Decorator** have similar structure but different intent

### Selection Flowchart

```
Problem: Object creation?
├─ YES → Creational patterns
│  ├─ Family of products? → Abstract Factory
│  ├─ Complex construction? → Builder
│  ├─ Subclass decides? → Factory Method
│  ├─ Clone existing? → Prototype
│  └─ Single instance? → Singleton (consider alternatives)
│
└─ NO → Problem: Object structure?
   ├─ YES → Structural patterns
   │  ├─ Interface conversion? → Adapter
   │  ├─ Separate interface/implementation? → Bridge
   │  ├─ Part-whole hierarchy? → Composite
   │  ├─ Add responsibilities dynamically? → Decorator
   │  ├─ Simplify subsystem? → Facade
   │  ├─ Share objects? → Flyweight
   │  └─ Control access? → Proxy
   │
   └─ NO → Problem: Object behavior?
      ├─ Chain of handlers? → Chain of Responsibility
      ├─ Encapsulate request? → Command
      ├─ Interpret language? → Interpreter
      ├─ Traverse aggregate? → Iterator
      ├─ Coordinate objects? → Mediator
      ├─ Save/restore state? → Memento
      ├─ Notify dependents? → Observer
      ├─ State-based behavior? → State
      ├─ Interchangeable algorithms? → Strategy
      ├─ Algorithm skeleton? → Template Method
      └─ Operations on structure? → Visitor
```

---

## Anti-Pattern Warning Signs

When considering patterns, watch for these red flags:

1. **Over-engineering**: Pattern adds more complexity than value
2. **Premature optimization**: Adding flexibility not yet needed (YAGNI)
3. **Pattern obsession**: Using pattern because it's cool, not because it solves problem
4. **Wrong pattern**: Pattern doesn't match actual problem structure
5. **Pattern mixing**: Combining patterns that work against each other
6. **Cargo culting**: Copying pattern structure without understanding intent

**Remember**: No pattern is better than the wrong pattern. Start simple, add patterns when pain points emerge.