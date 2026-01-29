# SOLID Principles Reference

SOLID is an acronym for five design principles that make software designs more understandable, flexible, and maintainable. Use these principles to evaluate and improve architectural decisions during brainstorming.

---

## Single Responsibility Principle (SRP)

**Definition:** A class should have one, and only one, reason to change.

### What it means

Each class should have a single, well-defined responsibility. If a class has multiple responsibilities, changes to one responsibility might impact or break the other.

### How to recognize violations

- Class has more than one reason to change
- Class name contains "And", "Or", "Manager", "Controller", "Handler" (often code smell)
- Methods in class operate on different subsets of fields
- Changes to unrelated features require modifying the same class
- Difficult to explain what class does in one sentence

### How to apply

1. **Identify responsibilities**: What does the class actually do?
2. **Separate concerns**: Extract each responsibility into its own class
3. **Name clearly**: Class name should reflect single responsibility
4. **Compose**: Use composition to combine responsibilities at higher level

### Example violations

```
❌ UserService that:
   - Validates user data
   - Saves users to database
   - Sends email notifications
   - Generates PDF reports
   - Handles authentication

Reasons to change: validation rules, database schema, email templates,
PDF format, authentication logic
```

### Better approach

```
✅ Separate classes:
   - UserValidator (validation rules)
   - UserRepository (database operations)
   - UserNotifier (email notifications)
   - UserReportGenerator (PDF generation)
   - AuthenticationService (authentication)

Each has ONE reason to change
```

### Benefits

- ✅ Easier to understand and maintain
- ✅ Changes are localized and less risky
- ✅ Better testability (smaller, focused tests)
- ✅ Reduced coupling

### Trade-offs

- ❌ Can lead to more classes
- ❌ May increase initial complexity
- ❌ Can be taken too far (nano-services anti-pattern)

### When to apply strictly

- Core domain logic
- Classes that change frequently
- Code that needs extensive testing
- Libraries and reusable components

### When to relax

- Simple utility classes
- Data transfer objects (DTOs)
- Small, stable classes
- When splitting would add significant complexity

---

## Open/Closed Principle (OCP)

**Definition:** Software entities should be open for extension but closed for modification.

### What it means

You should be able to add new functionality without changing existing code. Existing, tested code should remain untouched when requirements evolve.

### How to recognize violations

- Adding new feature requires modifying existing classes
- Large switch/if-else statements on type codes
- Modifying class to handle new cases
- Adding new enum values requires changes throughout codebase
- "Shotgun surgery" code smell (one change touches many files)

### How to apply

1. **Identify variation points**: What changes frequently?
2. **Abstract the variation**: Create interface or abstract class
3. **Implement extensions**: New behavior in new classes
4. **Use polymorphism**: Let runtime select appropriate implementation
5. **Apply patterns**: Strategy, Template Method, Decorator, etc.

### Example violations

```
❌ Payment processor with switch statement:
   switch (paymentType) {
     case CREDIT_CARD: processCreditCard()
     case PAYPAL: processPayPal()
     case BITCOIN: // Added later, modified switch
   }

Adding new payment method requires modifying existing code
```

### Better approach

```
✅ Use polymorphism:
   interface PaymentProcessor {
     process(amount)
   }

   class CreditCardProcessor implements PaymentProcessor
   class PayPalProcessor implements PaymentProcessor
   class BitcoinProcessor implements PaymentProcessor

Adding new payment method = new class, no modifications
```

### Common techniques

1. **Polymorphism/Inheritance**: Extend through subclassing
2. **Composition**: Combine behaviors at runtime
3. **Strategy Pattern**: Encapsulate varying algorithms
4. **Template Method**: Override specific steps
5. **Plugins**: Dynamic loading of extensions

### Benefits

- ✅ Existing code stays stable
- ✅ Less risk of breaking working features
- ✅ Easier to add new features
- ✅ Better code organization

### Trade-offs

- ❌ Initial design takes more effort
- ❌ Can lead to over-abstraction
- ❌ May have performance overhead
- ❌ Can be unclear which abstractions to create upfront

### When to apply strictly

- Core algorithms that need variants
- Systems with frequent feature additions
- Plugin architectures
- Libraries used by many clients

### When to relax

- Code that rarely changes
- Highly stable requirements
- Performance-critical sections
- When abstraction would be premature (YAGNI)

### Key insight

**Don't try to make everything extensible upfront** (violates YAGNI). Apply OCP when you **see** variation happening, not when you **imagine** it might happen.

---

## Liskov Substitution Principle (LSP)

**Definition:** Objects of a superclass should be replaceable with objects of a subclass without breaking the application.

### What it means

If class B is a subtype of class A, you should be able to use B anywhere A is expected, without the program behaving incorrectly. Subtypes must fulfill the contract of their parent type.

### How to recognize violations

- Subclass throws exceptions parent doesn't throw
- Subclass has stricter preconditions (requires more to work)
- Subclass has weaker postconditions (delivers less than promised)
- Subclass changes behavior in unexpected ways
- Need type checking or downcasting
- Subclass overrides method to do nothing or throw exception

### Common violation patterns

1. **Empty/exception overrides**
   ```
   ❌ class Bird {
      fly() { /* flies */ }
   }
   class Penguin extends Bird {
      fly() { throw new Error("Can't fly!") }
   }
   ```

2. **Strengthened preconditions**
   ```
   ❌ class Rectangle {
      setWidth(w) { width = w }  // Works with any number
   }
   class Square extends Rectangle {
      setWidth(w) {
        if (w != height) throw Error  // Requires w == height
      }
   }
   ```

3. **Weakened postconditions**
   ```
   ❌ class PaymentProcessor {
      process() { /* returns transaction ID */ }
   }
   class FailingProcessor extends PaymentProcessor {
      process() { /* returns null sometimes */ }
   }
   ```

### How to apply

1. **Design by contract**: Document expectations clearly
2. **Respect method contracts**:
   - Preconditions: subclass cannot require more
   - Postconditions: subclass cannot promise less
   - Invariants: must be preserved
3. **No type checking**: If you need `instanceof`, LSP likely violated
4. **Behavioral consistency**: Subclass shouldn't surprise users
5. **Exception consistency**: Don't throw new unchecked exceptions

### Classic example: Rectangle/Square

```
❌ WRONG: Square extends Rectangle
   Problem: Setting width and height independently breaks square invariant

✅ RIGHT: Rectangle and Square implement Shape
   Each has appropriate methods, no false inheritance
```

### Better bird hierarchy

```
✅ CORRECT:
   class Bird { eat(), sleep() }
   class FlyingBird extends Bird { fly() }
   class FlightlessBird extends Bird { /* no fly() */ }
   class Penguin extends FlightlessBird
   class Sparrow extends FlyingBird
```

### Benefits

- ✅ Predictable polymorphism
- ✅ Reliable abstractions
- ✅ Code reuse without surprises
- ✅ Safer refactoring

### Trade-offs

- ❌ May need rethinking inheritance hierarchies
- ❌ Can lead to more interfaces/classes
- ❌ Requires careful design of contracts

### When to apply strictly

- Public APIs and libraries
- Framework base classes
- Core domain hierarchies
- Anywhere polymorphism is used

### When to relax

- Private implementation details
- One-off specialized classes
- When inheritance isn't actually used polymorphically

### Key tests

Ask yourself:
1. Can I use subclass everywhere parent is used?
2. Would I be surprised by subclass behavior?
3. Do I need to check types before calling methods?
4. Does subclass violate "is-a" relationship?

If any answer is concerning, LSP may be violated.

---

## Interface Segregation Principle (ISP)

**Definition:** Clients should not be forced to depend on interfaces they don't use.

### What it means

Large, "fat" interfaces should be split into smaller, more specific ones. Clients should only know about methods that are relevant to them.

### How to recognize violations

- Interface has many methods
- Classes implementing interface leave some methods empty or throw "not implemented"
- Implementing interface requires stubbing many methods
- Changes to one method affect clients that don't use it
- Interface has methods for different types of clients

### Example violations

```
❌ Fat interface:
   interface Worker {
     work()
     eat()
     sleep()
     getPaid()
     attendMeeting()
     submitTimesheet()
     accessBuilding()
   }

   Robot implements Worker {
     work() { /* OK */ }
     eat() { /* Robots don't eat! */ }
     sleep() { /* Robots don't sleep! */ }
     ...
   }
```

### Better approach

```
✅ Segregated interfaces:
   interface Workable { work() }
   interface Feedable { eat() }
   interface Sleepable { sleep() }
   interface Payable { getPaid() }

   class Human implements Workable, Feedable, Sleepable, Payable
   class Robot implements Workable, Payable
```

### How to apply

1. **Identify client groups**: Who uses the interface?
2. **Group by usage**: What methods does each client need?
3. **Split interface**: Create smaller, focused interfaces
4. **Compose**: Classes can implement multiple interfaces
5. **Use role interfaces**: Name interfaces by role/capability

### Benefits

- ✅ Reduced coupling
- ✅ Better understanding (focused interfaces)
- ✅ Easier to implement (less to stub)
- ✅ More flexible composition
- ✅ Changes don't ripple to uninvolved clients

### Trade-offs

- ❌ More interfaces to manage
- ❌ Can be harder to discover all related interfaces
- ❌ May need interface adapter/facade

### When to apply strictly

- Public APIs
- Frameworks and libraries
- Interfaces with multiple implementations
- Interfaces used by diverse clients

### When to relax

- Internal implementations
- Interfaces with very few methods
- Interfaces unlikely to change
- When clients genuinely need all methods

### Key principle

**Many client-specific interfaces are better than one general-purpose interface.**

### Related concepts

- **Role interfaces**: Interfaces named by role (Printable, Serializable)
- **Header interfaces**: Small interfaces for specific capabilities
- **Composition over inheritance**: Combine small interfaces rather than big base class

---

## Dependency Inversion Principle (DIP)

**Definition:**
1. High-level modules should not depend on low-level modules. Both should depend on abstractions.
2. Abstractions should not depend on details. Details should depend on abstractions.

### What it means

Depend on abstractions (interfaces, abstract classes) rather than concrete implementations. This "inverts" the typical dependency direction where high-level code depends on low-level utilities.

### Traditional dependency direction

```
❌ High-level → Low-level (concrete)

   UserService → MySQLDatabase
   UserService → SendGridEmailer
   UserService → S3FileStorage

   High-level module depends on concrete implementations
```

### Inverted dependency direction

```
✅ High-level → Abstraction ← Low-level (concrete)

   UserService → IDatabase ← MySQLDatabase
   UserService → IEmailer ← SendGridEmailer
   UserService → IStorage ← S3FileStorage

   Both depend on abstraction, details are pluggable
```

### How to recognize violations

- Importing/using concrete classes directly
- Using `new` to create dependencies
- Hard-coded file paths, URLs, connection strings
- Direct references to frameworks or libraries
- Difficult to test without real database/network
- Can't swap implementations easily

### How to apply

1. **Extract interfaces**: Define abstractions for dependencies
2. **Depend on abstractions**: Reference interface, not implementation
3. **Inject dependencies**: Pass dependencies from outside (dependency injection)
4. **Invert ownership**: High-level module owns interface, low-level implements it
5. **Use factories/IoC**: Manage object creation separately

### Example violation

```
❌ Direct dependency:
   class UserService {
     constructor() {
       this.db = new MySQLDatabase("localhost", "users", "password")
       this.emailer = new SendGridEmailer("api-key-12345")
     }

     createUser(data) {
       this.db.insert(data)
       this.emailer.send(data.email, "Welcome!")
     }
   }

Problems:
- Can't test without MySQL and SendGrid
- Can't swap to Postgres or Mailgun
- Hard-coded configuration
```

### Better approach

```
✅ Depend on abstractions:
   interface IDatabase {
     insert(data)
     find(id)
   }

   interface IEmailer {
     send(to, message)
   }

   class UserService {
     constructor(db: IDatabase, emailer: IEmailer) {
       this.db = db
       this.emailer = emailer
     }

     createUser(data) {
       this.db.insert(data)
       this.emailer.send(data.email, "Welcome!")
     }
   }

   // Composition root (main)
   const db = new MySQLDatabase(config.db)
   const emailer = new SendGridEmailer(config.email)
   const service = new UserService(db, emailer)

Benefits:
- Testable (inject mocks)
- Swappable implementations
- Configuration externalized
- High-level logic independent of low-level details
```

### Dependency injection techniques

1. **Constructor injection**: Pass via constructor (preferred)
2. **Property injection**: Set via property after construction
3. **Method injection**: Pass to method that needs it
4. **Factory injection**: Inject factory that creates dependency
5. **IoC container**: Framework manages all dependencies

### Benefits

- ✅ Testability (inject mocks/stubs)
- ✅ Flexibility (swap implementations)
- ✅ Maintainability (isolated changes)
- ✅ Reusability (high-level logic portable)
- ✅ Delayed decisions (choose implementation later)

### Trade-offs

- ❌ More abstractions to manage
- ❌ Initial setup complexity
- ❌ May obscure code flow
- ❌ Potential performance overhead

### When to apply strictly

- Core business logic
- Testable code
- Systems with multiple implementations
- Code that depends on external systems
- Long-lived applications

### When to relax

- Stable, trusted dependencies (language standard library)
- Performance-critical code
- Simple scripts or prototypes
- Internal implementation details

### Key insight

**DIP enables the Open/Closed Principle.** By depending on abstractions, you can extend behavior by adding new implementations without modifying existing code.

---

## Applying SOLID: A Practical Workflow

### 1. Start with SRP

- Is this class doing too much?
- Can I describe its responsibility in one sentence?
- Would extract-class refactoring make sense?

### 2. Apply OCP when variation appears

- Am I constantly modifying this code for new cases?
- Would an abstraction make adding variants easier?
- Don't over-abstract prematurely (YAGNI)

### 3. Check LSP in hierarchies

- Can I use subclasses anywhere parent is expected?
- Am I type-checking or downcasting?
- Does subclass behavior surprise me?

### 4. Segregate interfaces as they grow

- Are implementers stubbing methods?
- Do different clients use different subsets?
- Split when pain is felt, not prematurely

### 5. Invert dependencies for flexibility

- Am I depending on concrete implementations?
- Would injection make this testable?
- Do I need to swap implementations?

---

## SOLID Anti-Patterns

Watch for these signs of SOLID violations:

### SRP violations
- God classes
- Classes with "Manager", "Handler", "Controller" in name
- Classes that change for unrelated reasons

### OCP violations
- Long switch/case or if/else chains on type
- Modifying existing code for every new feature
- "Shotgun surgery" across many files

### LSP violations
- Empty method implementations
- Throwing "not supported" exceptions
- Type checking before calling methods

### ISP violations
- Interfaces with 10+ methods
- NotImplementedException in implementers
- "I don't need 90% of this interface"

### DIP violations
- `new` scattered throughout code
- Hard-coded configuration
- Difficult to unit test
- "I can't swap this dependency"

---

## Common Misconceptions

### "SOLID means no concrete classes"
**False.** SOLID doesn't ban concrete classes. It says depend on abstractions *when you need flexibility*. For stable, internal implementations, concrete classes are fine.

### "Apply all principles everywhere"
**False.** SOLID principles are guidelines, not rules. Apply them where they add value. Don't create interfaces for every class or split every class into tiny pieces.

### "More classes/interfaces = better design"
**False.** SOLID can lead to more classes, but that's not the goal. Goal is flexibility, maintainability, and testability. Sometimes fewer, well-designed classes are better.

### "SOLID is only for OOP"
**Partially false.** While formulated for OOP, concepts translate to other paradigms:
- SRP → Single-purpose functions/modules
- OCP → Pure functions, immutability
- LSP → Type safety, contracts
- ISP → Minimal function parameters
- DIP → Higher-order functions, dependency injection

---

## When to Prioritize Each Principle

### SRP: Always
The most universally applicable. Even small functions benefit from single responsibility.

### DIP: High-value systems
Essential for testability and flexibility. Apply early in business logic.

### OCP: When variation emerges
Don't try to predict all extensions. Apply when you see the pattern of change.

### LSP: When using inheritance
Critical for class hierarchies. If not using inheritance much, less relevant.

### ISP: When interfaces grow
Start simple, segregate when different clients emerge with different needs.

---

## SOLID and Design Patterns

SOLID principles are supported by many design patterns:

- **SRP**: Strategy, Command, Facade
- **OCP**: Strategy, Template Method, Decorator, Observer
- **LSP**: Factory Method, Template Method
- **ISP**: Adapter, Facade
- **DIP**: Abstract Factory, Dependency Injection, Service Locator

Design patterns are concrete implementations of SOLID principles in action.
