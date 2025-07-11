# Spring Framework Petclinic

A Spring Framework application utilizing JSP, Spring MVC, Spring Data JPA, Hibernate, and JDBC.

## Quick Start (New Developer Setup)

After cloning this repository, run the automated setup script:

```bash
# One-time setup after cloning
./setup.sh
```

This will:
- Verify prerequisites (Java, Maven, Python, Git)
- Install AI-powered git hooks
- Verify Maven build
- Configure IDE settings
- Prepare development environment

### Alternative Setup Methods

**Option 1: Maven Auto-Installation** (Recommended for CI/CD)
```bash
# Git hooks will be auto-installed when running any Maven command
mvn compile
# or
mvn test
```

**Option 2: Manual Git Hooks Installation**
```bash
./install-hooks.sh
```

**Option 3: Skip Git Hooks (if needed)**
```bash
mvn compile -Dhooks.skip=true
```

## AI-Powered Git Hooks

This repository includes intelligent git hooks that enhance your development workflow:

### Features
- **Pre-commit Hook**: Automatically runs quality checks before each commit
- **Commit Message Hook**: Enhances commit messages using AI analysis
- **Team Synchronization**: Hooks are version-controlled and shared across the team

### Management Commands
```bash
./install-hooks.sh     # Install/reinstall hooks
./uninstall-hooks.sh   # Remove hooks
./setup.sh            # Complete development environment setup
```

## Prerequisites

- **Java 17+**: Required for Spring Framework 6.x
- **Maven 3.8.4+**: Build and dependency management
- **Python 3.6+**: For AI-powered git hooks
- **Git**: Version control

## Development Workflow

1. **Clone and Setup**:
   ```bash
   git clone <repository-url>
   cd spring-framework-petclinic
   ./setup.sh
   ```

2. **Development**:
   ```bash
   # Start development server
   mvn jetty:run
   
   # Access application
   open http://localhost:8080/petclinic
   ```

3. **Testing**:
   ```bash
   # Run all tests
   mvn test
   
   # Run specific test
   mvn test -Dtest=OwnerControllerTests
   ```

4. **Committing** (AI-Enhanced):
   ```bash
   git add .
   git commit -m "feat: Add new feature"
   # Pre-commit hook runs quality checks
   # Commit-msg hook enhances your message
   ```

## Available Profiles

The application supports multiple database profiles:

### H2 Database (Default)
```bash
mvn jetty:run
# or explicitly
mvn jetty:run -P H2
```

### HSQLDB
```bash
mvn jetty:run -P HSQLDB
```

### MySQL
```bash
mvn jetty:run -P MySQL
```

### PostgreSQL
```bash
mvn jetty:run -P PostgreSQL
```

## Build and Package

```bash
# Clean and compile
mvn clean compile

# Run tests
mvn test

# Package as WAR
mvn clean package

# Package and skip tests
mvn clean package -DskipTests
```

## Docker Support

Build and run with Docker:

```bash
# Build Docker image
mvn jib:build

# Run with Docker Compose (if available)
docker-compose up
```

## Frontend Development

For SCSS compilation:

```bash
# Compile SCSS to CSS
mvn compile -P css
```

## Code Quality

The project includes automated quality checks:

- **Pre-commit Hooks**: Run before each commit
- **Maven Enforcer**: Ensures proper Java/Maven versions
- **JaCoCo**: Code coverage analysis
- **SonarQube**: Static code analysis (configured for SonarCloud)

## Project Structure

```
spring-framework-petclinic/
├── hooks/                 # Git hooks (shared with team)
├── .git-hooks/           # Python scripts for AI integration
├── src/
│   ├── main/
│   │   ├── java/         # Java source code
│   │   ├── resources/    # Configuration and resources
│   │   └── webapp/       # JSP views and static resources
│   └── test/             # Test sources
├── setup.sh             # Development environment setup
├── install-hooks.sh     # Git hooks installation
├── uninstall-hooks.sh   # Git hooks removal
└── pom.xml              # Maven configuration
```

## Contributing

1. Run the setup script: `./setup.sh`
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes (git hooks will assist with quality)
4. Commit your changes: `git commit -m 'feat: Add amazing feature'`
5. Push to the branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

## Troubleshooting

### Git Hooks Not Working
```bash
# Check hook permissions
ls -la .git/hooks/

# Reinstall hooks
./uninstall-hooks.sh
./install-hooks.sh

# Check Python availability
python3 --version
```

### Maven Build Issues
```bash
# Clean and rebuild
mvn clean compile

# Skip hooks if causing issues
mvn compile -Dhooks.skip=true

# Check Java version
java -version
```

### Database Connection Issues
```bash
# For MySQL/PostgreSQL, ensure database is running
# Check connection settings in pom.xml profiles
```

## License

This project is licensed under the same terms as the original Spring PetClinic sample application.

---

**Happy coding with AI-enhanced development workflow!**




